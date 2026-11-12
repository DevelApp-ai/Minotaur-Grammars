#!/usr/bin/env bash
# Deterministic grammar packaging for Minotaur-Grammars releases
# (called by .github/workflows/release-grammars.yml; runnable locally).
#
# Discovers every grammar folder - a directory containing a
# minotaur-metadata.json - excluding test-grammars/ (test fixtures, not
# marketplace content), and packages each one as a byte-deterministic
# <Id>-<Version>.tar.gz, plus:
#
#   SHA256SUMS            GNU sha256sum -c compatible; sorted by file name
#   release-manifest.json id/name/version/category/path/tarball/sha256
#                         per grammar (no clock or host input)
#
# Determinism contract (org decision #26 spirit - same input, same bytes,
# on any machine at any time):
#   - archive entries sorted by name, GNU tar format
#   - fixed entry mtime 1970-01-01T00:00:00Z, owner/group 0
#   - gzip without name/timestamp (-n)
#   - no clocks, no host paths, no git metadata in any output
#
# Usage: scripts/package-grammars.sh <output-dir> [repo-root]
set -euo pipefail

out_dir="${1:?usage: scripts/package-grammars.sh <output-dir> [repo-root]}"
root="${2:-$(pwd)}"

command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 2; }
command -v sha256sum >/dev/null 2>&1 || { echo "sha256sum is required" >&2; exit 2; }
tar --version 2>/dev/null | grep -q 'GNU tar' || {
  echo "GNU tar is required (BSD/macOS tar lacks --sort/--mtime/--numeric-owner)." >&2
  exit 2
}

export LC_ALL=C
umask 022

# Resolve the output directory relative to the CALLER's working directory
# before switching to the repository root.
mkdir -p "$out_dir"
out_dir="$(cd "$out_dir" && pwd)"

cd "$root"

# Discovery: every grammar folder outside test-grammars/.
mapfile -t meta_files < <(find . -name minotaur-metadata.json -type f \
  -not -path './test-grammars/*' | sort)
if [ "${#meta_files[@]}" -eq 0 ]; then
  echo "No grammar folders found - nothing to package." >&2
  exit 2
fi

sums_tmp="$(mktemp)"
records_tmp="$(mktemp)"
trap 'rm -f "$sums_tmp" "$records_tmp"' EXIT

declare -A seen_ids=() seen_tarballs=()

for meta in "${meta_files[@]}"; do
  meta="${meta#./}"
  folder="${meta%/*}"
  id="$(jq -r '.Id // empty' "$meta")"
  name="$(jq -r '.Name // empty' "$meta")"
  version="$(jq -r '.Version // empty' "$meta")"
  main_file="$(jq -r '.MainFile // empty' "$meta")"

  if [ -z "$id" ] || [ -z "$name" ] || [ -z "$version" ]; then
    echo "$folder: minotaur-metadata.json must define Id, Name and Version." >&2
    exit 2
  fi
  case "$id" in
    *[!A-Za-z0-9._-]*)
      echo "$folder: grammar Id '$id' contains characters outside [A-Za-z0-9._-]." >&2
      exit 2 ;;
  esac
  case "$version" in
    *[!A-Za-z0-9._-]*)
      echo "$folder: grammar Version '$version' contains characters outside [A-Za-z0-9._-]." >&2
      exit 2 ;;
  esac
  if [ -z "$main_file" ] || [ ! -f "$folder/$main_file" ]; then
    echo "$folder: MainFile '$main_file' not found in the grammar folder." >&2
    exit 2
  fi
  if [ -n "${seen_ids[$id]:-}" ]; then
    echo "Duplicate grammar Id '$id' in ${seen_ids[$id]} and $folder." >&2
    exit 2
  fi
  seen_ids["$id"]="$folder"

  tarball="${id}-${version}.tar.gz"
  if [ -n "${seen_tarballs[$tarball]:-}" ]; then
    echo "Duplicate package name '$tarball' (${seen_tarballs[$tarball]} and $folder) - bump the grammar Version." >&2
    exit 2
  fi
  seen_tarballs["$tarball"]="$folder"

  tar --sort=name --format=gnu --mtime='@0' --owner=0 --group=0 --numeric-owner \
      -C "$folder" -cf - . | gzip -n > "$out_dir/$tarball"
  sha="$(sha256sum "$out_dir/$tarball" | cut -d' ' -f1)"

  category="${folder%/*}"
  printf '%s  %s\n' "$sha" "$tarball" >> "$sums_tmp"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$id" "$name" "$version" "$category" "$folder" "$tarball" "$sha" >> "$records_tmp"
  echo "packaged $tarball  ($folder)"
done

# SHA256SUMS, sorted by file name; GNU sha256sum -c compatible.
sort -k2,2 -o "$out_dir/SHA256SUMS" "$sums_tmp"

# release-manifest.json - one record per grammar, in discovery order
# (path-sorted).
jq -R -s '
  split("\n") | map(select(length > 0)) | map(split("\t")) |
  { grammars: map({
      id: .[0], name: .[1], version: .[2], category: .[3],
      path: .[4], tarball: .[5], sha256: .[6]
    }) }
' "$records_tmp" > "$out_dir/release-manifest.json"

echo "Wrote $out_dir/SHA256SUMS and $out_dir/release-manifest.json"
echo "Packaged ${#meta_files[@]} grammar package(s)."
