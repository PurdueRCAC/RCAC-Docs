#!/usr/bin/env bash
# ./tools/update_ngc_catalog.sh
# Regenerate the overview paragraph + container table in docs/software/ngc_catalog.md,
# injecting them between the <!-- NGC_TABLE_START --> / <!-- NGC_TABLE_END --> markers.
# The hand-written intro above the markers is preserved. Reads modulefiles directly.

set -euo pipefail

MODULEDIR="../modulefiles"
MD_DIR="../docs/software/ngc_md"
CATALOG_FILE="../docs/software/ngc_catalog.md"

# --- Shared scan: list real NGC container .lua files (one per line) ---
list_ngc_lua() {
  find "$MODULEDIR" -path "*/ngc/*" -name "*.lua" \( -type f -o -type l \) \
    ! -name "default" \
    ! -name ".modulerc.lua" \
    ! -regex '.*-[a-zA-Z0-9]\{7\}\.lua$' \
    ! -path "*/Core/*" \
    ! -path "*/modtree/*" 2>/dev/null
}
ngc_cluster() { local rel="${1#"$MODULEDIR"/}"; echo "${rel%%/*}"; }
ngc_app()     { basename "$(dirname "$1")"; }

# --- Stats ---
today=$(date +"%B %d, %Y")
container_count=$(find "$MD_DIR" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
version_count=$(list_ngc_lua | wc -l | tr -d ' ')
mapfile -t all_clusters < <(list_ngc_lua | while read -r f; do ngc_cluster "$f"; done | sort -u)
cluster_count=${#all_clusters[@]}
cluster_names=$(printf '%s\n' "${all_clusters[@]}" | tr '[:lower:]' '[:upper:]' | paste -sd "," - | sed 's/,/, /g')

# --- Build the generated block (overview paragraph + table) ---
BLOCK_FILE="$(mktemp)"
trap 'rm -f "$BLOCK_FILE"' EXIT
{
  echo "As of **$today**, there have been a total of **$container_count** NGC containers with **$version_count** available versions deployed across **$cluster_count** RCAC HPC clusters: **$cluster_names**."
  echo
  echo '<table id="ngcTable" class="tablefilter">'
  echo "  <thead>"
  echo "    <tr><th scope=\"col\"><strong>Container</strong></th><th scope=\"col\"><strong>Available at</strong></th></tr>"
  echo "  </thead>"
  echo "  <tbody>"

  find "$MD_DIR" -type f -name "*.md" | sort | while read -r filepath; do
    app=$(basename "$filepath" .md)
    clusters=$(list_ngc_lua | while read -r f; do
      [[ "$(ngc_app "$f")" == "$app" ]] && ngc_cluster "$f" || true
    done | tr '[:lower:]' '[:upper:]' | sort -u | paste -sd "," - | sed 's/,/, /g' || true)
    echo "    <tr>"
    echo "      <td><a href=\"../ngc_md/$app\"><strong>$app</strong></a></td>"
    echo "      <td>$clusters</td>"
    echo "    </tr>"
  done

  echo "  </tbody>"
  echo "</table>"
} > "$BLOCK_FILE"

# --- Inject between sentinel markers (preserve everything else) ---
awk -v block="$BLOCK_FILE" '
  /<!-- NGC_TABLE_START -->/ {
    print
    while ((getline line < block) > 0) print line
    close(block)
    skip = 1
    next
  }
  /<!-- NGC_TABLE_END -->/ { skip = 0 }
  !skip { print }
' "$CATALOG_FILE" > "${CATALOG_FILE}.new"

mv "${CATALOG_FILE}.new" "$CATALOG_FILE"
echo "✅ Updated NGC catalog table in $CATALOG_FILE ($container_count containers, $version_count versions)."
