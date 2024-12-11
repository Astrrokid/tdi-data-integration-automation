#!/bin/bash

DATA_HUB="data-hub"
DB="db"
OUTPUT_FILE="$DB/consolidated_data.csv"
PROCESSED_LOG="$DB/processed_files.log"

# Ensure required directories and files exist
mkdir -p "$DB"
touch "$PROCESSED_LOG"

# Find unprocessed files
NEW_DATA_FILES=()
for file in "$DATA_HUB"/*.csv; do
  if ! grep -Fxq "$file" "$PROCESSED_LOG"; then
    NEW_DATA_FILES+=("$file")
  fi
done

if [ ${#NEW_DATA_FILES[@]} -eq 0 ]; then
  echo "No new data files detected."
  exit 0
fi

echo "New data detected. Processing..."
if [ ! -f "$OUTPUT_FILE" ]; then
  head -1 "${NEW_DATA_FILES[0]}" > "$OUTPUT_FILE" 
fi

for file in "${NEW_DATA_FILES[@]}"; do
  tail -n +2 "$file" >> "$OUTPUT_FILE"
  echo "$file" >> "$PROCESSED_LOG"     
done

echo "Data integration complete. Updated file saved to $OUTPUT_FILE."
