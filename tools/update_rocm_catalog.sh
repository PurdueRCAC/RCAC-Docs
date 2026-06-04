#!/usr/bin/env bash
# ./tools/update_rocm_catalog.sh
# Regenerate the overview paragraph + container table in docs/software/rocm_catalog.md,
# injecting them between the <!-- ROCM_TABLE_START --> / <!-- ROCM_TABLE_END --> markers.
# The hand-written intro above the markers is preserved. Reads modulefiles directly.

set -euo pipefail

MODULEDIR="../modulefiles"
MD_DIR="../docs/software/rocm_md"
CATALOG_FILE="../docs/software/rocm_catalog.md"

# --- Shared scan: list real ROCm container .lua files (one per line) ---
list_rocm_lua() {
  find "$MODULEDIR" -path "*/rocmcontainers/*" -name "*.lua" \( -type f -o -type l \) \
    ! -name "default" \
    ! -name ".modulerc.lua" \
    ! -regex '.*-[a-zA-Z0-9]\{7\}\.lua$' \
    ! -path "*/Core/*" \
    ! -path "*/modtree/*" 2>/dev/null
}
rocm_cluster() { local rel="${1#"$MODULEDIR"/}"; echo "${rel%%/*}"; }
rocm_app()     { basename "$(dirname "$1")"; }

# --- Stats ---
today=$(date +"%B %d, %Y")
container_count=$(find "$MD_DIR" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
version_count=$(list_rocm_lua | wc -l | tr -d ' ')
mapfile -t all_clusters < <(list_rocm_lua | while read -r f; do rocm_cluster "$f"; done | sort -u)
cluster_count=${#all_clusters[@]}
cluster_names=$(printf '%s\n' "${all_clusters[@]}" | tr '[:lower:]' '[:upper:]' | paste -sd "," - | sed 's/,/, /g')

# --- Build the generated block (overview paragraph + table) ---
BLOCK_FILE="$(mktemp)"
trap 'rm -f "$BLOCK_FILE"' EXIT
{
  echo "As of **$today**, there have been a total of **$container_count** ROCm containers with **$version_count** available versions deployed across **$cluster_count** RCAC HPC clusters: **$cluster_names**."
  echo
  echo '<table id="rocmTable" class="tablefilter container-catalog-table">'
  echo "  <thead>"
  echo "    <tr><th scope=\"col\"><strong>Container</strong></th><th scope=\"col\"><strong>Available at</strong></th></tr>"
  echo "  </thead>"
  echo "  <tbody>"

  find "$MD_DIR" -type f -name "*.md" | sort | while read -r filepath; do
    app=$(basename "$filepath" .md)
    clusters=$(list_rocm_lua | while read -r f; do
      [[ "$(rocm_app "$f")" == "$app" ]] && rocm_cluster "$f" || true
    done | tr '[:lower:]' '[:upper:]' | sort -u | paste -sd "," - | sed 's/,/, /g' || true)
    echo "    <tr>"
    echo "      <td><a href=\"../rocm_md/$app\"><strong>$app</strong></a></td>"
    echo "      <td>$clusters</td>"
    echo "    </tr>"
  done

  echo "  </tbody>"
  echo "</table>"
} > "$BLOCK_FILE"

# --- Inject between sentinel markers ---
awk -v block="$BLOCK_FILE" '
  /<!-- ROCM_TABLE_START -->/ {
    print
    while ((getline line < block) > 0) print line
    close(block)
    skip = 1
    next
  }
  /<!-- ROCM_TABLE_END -->/ { skip = 0 }
  !skip { print }
' "$CATALOG_FILE" > "${CATALOG_FILE}.new"

mv "${CATALOG_FILE}.new" "$CATALOG_FILE"
echo "✅ Updated ROCm catalog table in $CATALOG_FILE ($container_count containers, $version_count versions)."
