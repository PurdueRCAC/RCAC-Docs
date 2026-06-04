#!/usr/bin/env bash
# ./tools/generate_rocm_md.sh
# Generate a markdown detail page for each ROCm container, read directly from the
# modulefiles tree (no intermediate inventory JSON).
#   - Containers: modulefiles/{cluster}/rocmcontainers/{app}/{version}.lua  (excludes */Core/*)
#   - Description & homepage extracted from each .lua whatis() lines
#   - Availability/versions derived from the filesystem
# Output: docs/software/rocm_md/{app}.md

set -euo pipefail

MODULEDIR="../modulefiles"
MD_DIR="../docs/software/rocm_md"

mkdir -p "$MD_DIR"

# --- Shared scan: list real ROCm container .lua files (one per line) ---
list_rocm_lua() {
  find "$MODULEDIR" -path "*/rocmcontainers/*" -name "*.lua" \( -type f -o -type l \) \
    ! -name "default" \
    ! -name ".modulerc.lua" \
    ! -regex '.*-[a-zA-Z0-9]\{7\}\.lua$' \
    ! -path "*/Core/*" \
    ! -path "*/modtree/*" 2>/dev/null
}

# parse helpers (path: modulefiles/{cluster}/rocmcontainers/{app}/{ver}.lua)
rocm_cluster() { local rel="${1#"$MODULEDIR"/}"; echo "${rel%%/*}"; }
rocm_app()     { basename "$(dirname "$1")"; }
rocm_version() { local f; f="$(basename "$1")"; echo "${f%.lua}"; }

# Unique container app names
mapfile -t APPS < <(list_rocm_lua | while read -r f; do rocm_app "$f"; done | sort -u)

for app in "${APPS[@]}"; do
  # All .lua files for this app across clusters
  mapfile -t app_files < <(list_rocm_lua | while read -r f; do
    [[ "$(rocm_app "$f")" == "$app" ]] && echo "$f" || true
  done)

  # Representative file (highest version) for description + URL
  rep=$(printf '%s\n' "${app_files[@]}" | sort -V | tail -1)
  desc=$(grep -m1 'whatis("Description:' "$rep" 2>/dev/null \
    | sed -E 's/.*whatis\("Description: ?(.*)"\).*/\1/' || true)
  url=$(grep -m1 'whatis("Home page:' "$rep" 2>/dev/null \
    | sed -E 's/.*whatis\("Home page: ?(.*)"\).*/\1/' || true)

  md_file="$MD_DIR/$app.md"
  {
    echo "# $app"
    echo ""
    echo "[Back to ROCm containers](../rocm_catalog.md)"
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
      echo "## Homepage"
      echo ""
      echo "[$url]($url)"
      echo ""
    fi
    echo "## Available Versions on RCAC Clusters"
    echo ""
    echo "|Cluster|Versions|"
    echo "|---|---|"

    has_default=0
    mapfile -t clusters < <(printf '%s\n' "${app_files[@]}" \
      | while read -r f; do rocm_cluster "$f"; done | sort -u)
    for cluster in "${clusters[@]}"; do
      appdir="$MODULEDIR/$cluster/rocmcontainers/$app"
      default_ver=""
      if [ -L "$appdir/default" ]; then
        dt=$(basename "$(readlink "$appdir/default")")
        default_ver="${dt%.lua}"
      fi
      mapfile -t vers < <(printf '%s\n' "${app_files[@]}" | while read -r f; do
        [[ "$(rocm_cluster "$f")" == "$cluster" ]] && rocm_version "$f" || true
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
    echo "module load rocmcontainers"
    echo "module load $app"
    echo '```'
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

echo "✅ Generated ${#APPS[@]} ROCm container pages in $MD_DIR"
