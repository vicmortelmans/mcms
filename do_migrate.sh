#!/bin/bash

# Usage:
#
#   ./do_migrate 2>&1 | tee "`date`.log"
 
# IXIASOFT export zip files are found in 'todo' subdirectory here:
export="/mnt/h/amcaj/0_Documentation/cms-exports"
temp="/mnt/d/tmp/export"

# Zip files are one by one unzipped and migrated
for f in $export/todo/*.zip; do
  echo "Processing $f"
  date
  n=${f##*/}  # remove path
  n=${n//[^a-zA-Z0-9]/-}  # slugify
  mkdir -p -v "$temp/$n.dir"
  cd "$temp/$n.dir"
  mkdir -p "published"
  cp -r "$temp/system" "published/"
  echo "Unzipping $f to $temp/$n.dir"
  unzip -n "$f"
  cd "/mnt/c/mcmsm"
  echo "Migrating"
  date
  python3 migrate.py "$temp/$n.dir"
  touch "$f"
  mv -v "$f" "$export/done/"
  echo "Cleaning up $temp/$n.dir"
  rm -Rf "$temp/$n.dir"
done

