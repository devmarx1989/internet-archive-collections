#!/usr/bin/env bash
set -euo pipefail

OUTPUT="big-urls.txt"
: > "$OUTPUT"

# Find every file literally named "urls"
while IFS= read -r -d '' file; do
  dir_abs="$(realpath "$(dirname "$file")")"

  # Read each non-empty line as a URL
  while IFS= read -r url || [[ -n "$url" ]]; do
    [[ -z "$url" ]] && continue
    clean="${url%%[\?#]*}"                 # strip ?query and #fragment
    fname="$(basename "$clean")"           # filename from URL

    printf '%s\n  dir=%s\n  out=%s\n\n' \
      "$url" "$dir_abs" "$fname" >> "$OUTPUT"
  done < "$file"

done < <(find . -type f -name urls -print0)

echo "Wrote $OUTPUT"

