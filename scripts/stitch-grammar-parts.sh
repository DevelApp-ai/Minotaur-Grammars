#!/usr/bin/env bash
# Stitch grammar chunk files into their target .grammar files.
#
# Chunk naming standard (see docs/large-grammar-transport.md):
#   .grammar-parts/<target-path-with-__-separators>.part-000, .part-001, ...
#   e.g. .grammar-parts/programming-languages__java17__Java17.grammar.part-000
#
# Lexicographic sort of the zero-padded part numbers equals numeric order.
# Chunks are split on newline boundaries; concatenation is byte-exact, so
# the stitched file is identical to the original.
#
# Usage:
#   scripts/stitch-grammar-parts.sh            # stitch all, keep parts
#   scripts/stitch-grammar-parts.sh --clean    # stitch all, delete parts
set -euo pipefail

if git rev-parse --show-toplevel >/dev/null 2>&1; then
  cd "$(git rev-parse --show-toplevel)"
fi

PARTS_DIR=".grammar-parts"
CLEAN=0
if [[ "${1:-}" == "--clean" ]]; then CLEAN=1; fi

if [[ ! -d "$PARTS_DIR" ]]; then
  echo "No $PARTS_DIR directory; nothing to stitch."
  exit 0
fi

stitched=0
# Group chunk files by target path (everything before ".part-NNN", with
# __ as path separator).
declare -A targets=()
for part in "$PARTS_DIR"/*.part-[0-9][0-9][0-9]; do
  [[ -f "$part" ]] || continue
  base="$(basename "$part")"
  base="${base%.part-*}"
  targets["$base"]+="$part"$'\n'
done

for base in "${!targets[@]}"; do
  target_path="${base//__//}"
  # One part per line; lexicographic sort = numeric order (zero-padded)
  mapfile -t sorted < <(printf '%s' "${targets[$base]}" | sort)
  mkdir -p "$(dirname "$target_path")"
  cat "${sorted[@]}" > "$target_path"
  echo "stitched ${#sorted[@]} parts -> $target_path ($(wc -c < "$target_path") bytes)"
  stitched=$((stitched+1))
  if [[ $CLEAN -eq 1 ]]; then rm -f "${sorted[@]}"; fi
done

if [[ $stitched -gt 0 && $CLEAN -eq 1 ]]; then
  rmdir "$PARTS_DIR" 2>/dev/null || true
fi
echo "stitched $stitched file(s)"
