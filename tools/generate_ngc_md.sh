#!/usr/bin/env bash
# ./tools/generate_ngc_md.sh
# Generate a markdown detail page for each NGC container, read directly from the
# modulefiles tree (no intermediate inventory JSON).
#   - Containers: modulefiles/{cluster}/ngc/{app}/{version}.lua  (excludes */Core/ngc/ loader)
#   - Description & NGC URL: extracted from each .lua whatis() lines
#   - Availability/versions: derived from the filesystem
# Output: docs/software/ngc_md/{app}.md

set -euo pipefail

MODULEDIR="../modulefiles"
MD_DIR="../docs/software/ngc_md"

mkdir -p "$MD_DIR"

# --- Shared scan: list real NGC container .lua files (one per line) ---
list_ngc_lua() {
  find "$MODULEDIR" -path "*/ngc/*" -name "*.lua" \( -type f -o -type l \) \
    ! -name "default" \
    ! -name ".modulerc.lua" \
    ! -regex '.*-[a-zA-Z0-9]\{7\}\.lua$' \
    ! -path "*/Core/*" \
    ! -path "*/modtree/*" 2>/dev/null
}

# parse helpers (path: modulefiles/{cluster}/ngc/{app}/{ver}.lua)
ngc_cluster() { local rel="${1#"$MODULEDIR"/}"; echo "${rel%%/*}"; }
ngc_app()     { basename "$(dirname "$1")"; }
ngc_version() { local f; f="$(basename "$1")"; echo "${f%.lua}"; }

# Unique container app names
mapfile -t APPS < <(list_ngc_lua | while read -r f; do ngc_app "$f"; done | sort -u)

for app in "${APPS[@]}"; do
  # All .lua files for this app across clusters
  mapfile -t app_files < <(list_ngc_lua | while read -r f; do
    [[ "$(ngc_app "$f")" == "$app" ]] && echo "$f"
  done)

  # Representative file (highest version) for description + URL
  rep=$(printf '%s\n' "${app_files[@]}" | sort -V | tail -1)
  desc=$(grep -m1 'whatis("Description:' "$rep" 2>/dev/null \
    | sed -E 's/.*whatis\("Description: ?(.*)"\).*/\1/' || true)
  # URL line is usually whatis("URL: ...") but some modulefiles use whatis("NGC: ...")
  url=$(grep -m1 -E 'whatis\("(URL|NGC):' "$rep" 2>/dev/null \
    | sed -E 's/.*whatis\("(URL|NGC): ?(.*)"\).*/\2/' || true)

  md_file="$MD_DIR/$app.md"
  {
    echo "# $app"
    echo ""
    echo "[Back to NGC containers](../ngc_catalog.md)"
    echo ""
    echo "## Description"
    echo ""
    if [ -n "$desc" ]; then
      echo "$desc"
    else
      echo "TODO: add description..."
    fi
    echo ""
    if [ -n "$url" ]; then
      echo "## NGC Catalog"
      echo ""
      echo "[$url]($url)"
      echo ""
    fi
    echo "## Available Versions on RCAC Clusters"
    echo ""
    echo "|Cluster|Versions|"
    echo "|---|---|"

    has_default=0
    # Clusters that have this app, sorted
    mapfile -t clusters < <(printf '%s\n' "${app_files[@]}" \
      | while read -r f; do ngc_cluster "$f"; done | sort -u)
    for cluster in "${clusters[@]}"; do
      appdir="$MODULEDIR/$cluster/ngc/$app"
      # default version (if a 'default' symlink exists)
      default_ver=""
      if [ -L "$appdir/default" ]; then
        dt=$(basename "$(readlink "$appdir/default")")
        default_ver="${dt%.lua}"
      fi
      # versions for this cluster
      mapfile -t vers < <(printf '%s\n' "${app_files[@]}" | while read -r f; do
        [[ "$(ngc_cluster "$f")" == "$cluster" ]] && ngc_version "$f"
      done | sort -V)
      row=""
      for v in "${vers[@]}"; do
        if [ -n "$default_ver" ] && [ "$v" == "$default_ver" ]; then
          row+="$v (D), "; has_default=1
        else
          row+="$v, "
        fi
      done
      row="${row%, }"
      echo "**${cluster^^}**|$row"
    done
    echo ""
    if [ "$has_default" -eq 1 ]; then
      echo "(D): Default Module"
      echo ""
    fi

    echo "## Module"
    echo ""
    echo "You can load the container module by:"
    echo ""
    echo '```bash'
    echo "module load ngc"
    echo "module load $app"
    echo '```'
    echo ""
    echo "!!! note \"Note for using \`$app\`\""
    echo "    Run \`module spider $app\` beforehand to check available versions and any prerequisite modules."
  } > "$md_file"
done

# Remove stale .md files no longer present as containers
find "$MD_DIR" -type f -name "*.md" | while read -r md_file; do
  app=$(basename "$md_file" .md)
  if ! printf '%s\n' "${APPS[@]}" | grep -qx "$app"; then
    echo "Removing stale: $md_file"
    rm "$md_file"
  fi
done

echo "✅ Generated ${#APPS[@]} NGC container pages in $MD_DIR"
