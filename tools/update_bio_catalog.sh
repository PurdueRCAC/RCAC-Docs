#!/usr/bin/env bash
# ./tools/update_bio_catalog.sh
# Regenerate the overview paragraph + biocontainer table in docs/software/biocontainer_catalog.md,
# injecting them between the <!-- BIO_TABLE_START --> / <!-- BIO_TABLE_END --> markers.
# The hand-written intro above the markers is preserved. Reads the RCAC Biocontainers inventory JSON.

set -euo pipefail

INVENTORY_URL="https://raw.githubusercontent.com/PurdueRCAC/Biocontainers/refs/heads/main/scripts/documentation/rcac_biocontainers_inventory.json"
DOC_BASE_URL="https://biocontainer-doc.readthedocs.io/source"
CATALOG_FILE="../docs/software/biocontainer_catalog.md"

command -v jq >/dev/null || { echo "❌ jq is required." >&2; exit 1; }

INVENTORY_FILE="$(mktemp)"
BLOCK_FILE="$(mktemp)"
trap 'rm -f "$INVENTORY_FILE" "$BLOCK_FILE"' EXIT

curl -fsSL "$INVENTORY_URL" -o "$INVENTORY_FILE"
jq -e 'type == "object" and length > 0' "$INVENTORY_FILE" >/dev/null \
  || { echo "❌ Inventory is empty or malformed: $INVENTORY_URL" >&2; exit 1; }

# --- Stats ---
today=$(date +"%B %d, %Y")
container_count=$(jq 'length' "$INVENTORY_FILE")
# Versions are counted per cluster deployment (same convention as the NGC catalog's .lua count)
version_count=$(jq '[.[] | .availability // {} | .[] | length] | add // 0' "$INVENTORY_FILE")
mapfile -t all_clusters < <(jq -r '[.[] | .availability // {} | keys[]] | unique | .[]' "$INVENTORY_FILE")
cluster_count=${#all_clusters[@]}
# Title-case names, joined as "A, B, C and D"
cluster_names=$(printf '%s\n' "${all_clusters[@]}" | sed 's/^./\U&/' \
  | paste -sd "," - | sed 's/,/, /g; s/\(.*\), /\1 and /')

# --- Build the generated block (overview paragraph + table) ---
{
  echo "As of **$today**, there have been a total of **$container_count** biocontainers with **$version_count** available versions deployed across **$cluster_count** RCAC HPC clusters: **$cluster_names**."
  echo
  echo '<table id="bioTable" class="tablefilter container-catalog-table">'
  echo "  <thead>"
  echo "    <tr><th scope=\"col\"><strong>Biocontainer</strong></th><th scope=\"col\"><strong>Available at</strong></th></tr>"
  echo "  </thead>"
  echo "  <tbody>"

  jq -r --arg base "$DOC_BASE_URL" '
    to_entries | sort_by(.key)[] |
    "    <tr>\n" +
    "      <td><a href=\"\($base)/\(.key)/\(.key).html\"><strong>\(.key)</strong></a></td>\n" +
    "      <td>\(.value.availability // {} | keys | map(ascii_upcase) | join(", "))</td>\n" +
    "    </tr>"
  ' "$INVENTORY_FILE"

  echo "  </tbody>"
  echo "</table>"
} > "$BLOCK_FILE"

grep -q '<!-- BIO_TABLE_START -->' "$CATALOG_FILE" \
  || { echo "❌ Missing <!-- BIO_TABLE_START --> marker in $CATALOG_FILE" >&2; exit 1; }

# --- Inject between sentinel markers (preserve everything else) ---
awk -v block="$BLOCK_FILE" '
  /<!-- BIO_TABLE_START -->/ {
    print
    while ((getline line < block) > 0) print line
    close(block)
    skip = 1
    next
  }
  /<!-- BIO_TABLE_END -->/ { skip = 0 }
  !skip { print }
' "$CATALOG_FILE" > "${CATALOG_FILE}.new"

mv "${CATALOG_FILE}.new" "$CATALOG_FILE"
echo "✅ Updated biocontainer catalog table in $CATALOG_FILE ($container_count containers, $version_count versions)."
