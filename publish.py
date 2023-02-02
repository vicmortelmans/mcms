#!/usr/bin/python3
from datetime import datetime, timezone
import pathlib
import sys
import stat
from tqdm import tqdm
from saxonche import PySaxonProcessor
import urllib.parse

# Run in WSL in /mnt/d/mcmsm as:
#
#   python3 publish.py authoring/<map_id>.ditamap
#
# This script finds all child dependencies (recursively) of the provided ditamap
# (in authoring) and copies these files into a new folder:
# 
#   published/en-us/<map_id>.ditamap_<version>
#
# Renaming all files from <id>.* to:
# 
#   <id>_<authoring_timestamp>.*
#
# Where:
#  - <version> is a "YYYYMMDD HHMM" timestamp, time of running this script, with the
#    base64 encoding of it appended (note: seems superfluous, but at some point this
#    script may be expanded to allow custom <version> strings, which cannot be safely
#    encoded in a filename!)
#  - <authoring_timestamp> is a "YYYYMMDDHHMM" timestamp, timestamp of the original file
#
# In the ditamap file(s) and xml files, a search-and-replace is performed to modify
# the filenames of topicrefs, images and conrefs.

version = datetime.today().strftime('%Y%m%d %H%M')
version_appendix = urllib.parse.quote_plus(version)

# Initialize the XSLT processor
saxon_proc = PySaxonProcessor(license=False)
print(saxon_proc.version)
print(f"(tested config: saxonche version 12 (saxon/c) with saxon 9.9)")
saxon_proc.set_catalog("catalog-wsl.xml")
xslt_proc = saxon_proc.new_xslt30_processor()

# Collect all children
print("Counting files...")
children = xslt_proc.transform_to_string(stylesheet_file="list_children.xslt", source_file=sys.argv[1]).splitlines()
children = list(set(children))  # remove duplicates
old_ditamap_path = pathlib.Path(sys.argv[1])
children.append(old_ditamap_path.name)

# Initialize the progress bar
total_file_count = len(children)
print(f"Total number of files: {total_file_count}")
pbar = tqdm(total=total_file_count)

# Generete paths and filenames for published files
map_id = old_ditamap_path.stem
files = []
for child in children:
  old_file_dir = pathlib.Path.cwd().joinpath("authoring")
  old_file_path = old_file_dir.joinpath(child)
  old_file_time = datetime.fromtimestamp(old_file_path.stat().st_mtime, tz=timezone.utc)
  old_file_time_string = old_file_time.strftime('%Y%m%d%H%M')
  new_file_dir = pathlib.Path.cwd().joinpath("published","en-us",f"{map_id}.ditamap_{version_appendix}")
  new_file_name = f"{old_file_path.stem}_{old_file_time_string}{old_file_path.suffix}"
  files.append((
    str(old_file_dir),
    str(child),
    str(new_file_dir),
    str(new_file_name)
  ))

# Iterate all files 
# The list 'files' contains all children of a single map and is used to
# search-and-replace references
for old_path, old_name, new_path, new_name in files:
  pathlib.Path(new_path).mkdir(parents=True, exist_ok=True)
  old_file = '/'.join([old_path, old_name])
  new_file = '/'.join([new_path, new_name])
  tqdm.write(f"{old_file} => {new_file}")
  # Images: copy file to new filename
  if pathlib.Path(old_name).suffix == '.svg':
    with open(old_file, 'rb') as old, open(new_file, 'wb') as new:
      new.write(old.read())
  # DITA maps
  elif pathlib.Path(old_name).suffix == '.ditamap':
    # search and replace references to files
    with open(old_file, 'r') as old, open(new_file, 'w') as new:
      for old_line in old:
        new_line = old_line
        # find and replace filenames
        for _, old_string, _, new_string in files:
          new_line = new_line.replace(old_string, new_string)
        new.write(new_line)
  # topic files
  else:
    # search and replace references to files
    with open(old_file, 'r') as old, open(new_file, 'w') as new:
      for old_line in old:
        new_line = old_line
        # find and replace filenames
        for _, old_string, _, new_string in files:
          new_line = new_line.replace(old_string, new_string)
        new.write(new_line)
  # make new file read only
  new_file.chmod(stat.S_IREAD)
  pbar.update(1)

tqdm.write(f"DONE: {len(files)} children of {sys.argv[1]}")

pbar.close()

    
  
