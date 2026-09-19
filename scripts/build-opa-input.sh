#!/usr/bin/env bash
# Builds the OPA input document (opa-input.json) describing every grammar
# folder in this repository, for use with:
#   opa eval -d policies -i opa-input.json 'data.minotaur'
#
# A grammar folder is any directory containing a minotaur-metadata.json file.
# Requires: bash, jq, find, grep.
set -euo pipefail

cd "$(dirname "$0")/.."

grammars='[]'
while IFS= read -r -d '' metadata; do
  dir="$(dirname "$metadata")"
  files='[]'
  while IFS= read -r f; do
    files=$(jq --arg f "${f#$dir/}" '. + [$f]' <<< "$files")
  done < <(find "$dir" -maxdepth 1 -type f -printf '%p\n' | sort)

  has_license=false
  spdx=""
  if [[ -f "$dir/LICENSE" ]]; then
    has_license=true
    spdx=$(grep -m1 -oE 'SPDX-License-Identifier: *[A-Za-z0-9.-]+' "$dir/LICENSE" \
      | head -1 | sed 's/SPDX-License-Identifier: *//' || true)
    if [[ -z "$spdx" ]]; then
      # Fall back to well-known license texts.
      if grep -q 'Apache License' "$dir/LICENSE"; then spdx="Apache-2.0"
      elif grep -q 'GNU GENERAL PUBLIC LICENSE' "$dir/LICENSE"; then spdx="GPL-3.0-only"
      elif grep -q 'Mozilla Public License' "$dir/LICENSE"; then spdx="MPL-2.0"
      elif grep -qi 'Permission is hereby granted, free of charge' "$dir/LICENSE"; then spdx="MIT"
      fi
    fi
  fi

  grammars=$(jq \
    --arg path "$dir" \
    --argjson files "$files" \
    --argjson has_license "$has_license" \
    --arg spdx "$spdx" \
    --slurpfile meta "$metadata" \
    '. + [{path: $path, files: $files, has_license_file: $has_license, license_spdx: $spdx, metadata: $meta[0]}]' \
    <<< "$grammars")
done < <(find . -name minotaur-metadata.json -not -path './.git/*' -print0 | sort -z)

jq -n '{grammars: $g}' --argjson g "$grammars" > opa-input.json
echo "Wrote opa-input.json with $(jq '.grammars | length' opa-input.json) grammar(s)."
