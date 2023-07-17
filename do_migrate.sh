#!/bin/bash
export="/mnt/h/amcaj/0_Documentation/cms-exports"
cd "/mnt/d/tmp/export"
for f in "$export/todo/*.zip"
do
  mkdir -p "$f.dir"
  cd "$f.dir"
  unzip -n "$f" >> "$export/$f.log" 2>> "$export/$f.err" &> /dev/stdout
  cd "/mnt/c/mcmsm"
  python3 migrate.py "/mnt/d/tmp/export/$f.dir" >> "$export/$f.log" 2>> "$export/$f.err" &> /dev/stdout
  mv "$f" "$export/done/"
done

