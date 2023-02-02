#!/usr/bin/python3
import base64
from datetime import datetime
import xml.etree.ElementTree as ET
import pathlib
from slugify import slugify
import subprocess
import sys
from tqdm import tqdm
from saxonche import PySaxonProcessor
import urllib.parse

# This script migrates the exported IXIASOFT CMS files from an export folder
# (containing 'published', 'localization' and 'authoring' folders), into the current CMS folder.
#
# Prerequisite: the 'system' folder, containing IXIASOFT DTD files, must be copied into
# '<export-folder>/published/system' and '<export-folder>/../system' (/mnt/d/).
#
# Run in WSL in the current CMS folder as:
#
#   python3 migrate.py <export-folder>
#
# All files are copied 1-1, but the names are changed:
#
#  - published folders are renamed to <map_id>.ditamap_<version>
#    where <version> is the uri-encoded version string (with space -> '+')
#  - published and localization files are renamed to 
#    <id>_<migration_timestamp>_<authoring_revision>
#
# The migration timestamp will be part of the filenames in published and localization.
# The authoring revision will be added as well.
# When in operation, the CMSM will use the authoring timestamp (file attribute) instead


#MIGRATION_TIMESTAMP = datetime.today().strftime('%Y%m%d%H%M')
MIGRATION_TIMESTAMP = "202301300844"


def get_new_ditamap_directory_for_published(first_ditamap):
  # old: <export-dir>\published\bg-bg\axk1438119883924_00004.ditamap_2
  # new: .\published\bg-bg\axk1438119883924.ditamap_20180409-1429_MjAxODA0MDkgMTQyOQ==
  customproperties = first_ditamap.with_suffix('.customproperties')
  try:
    cptree = ET.parse(str(customproperties))
  except Exception as e:
    e.args = ("ERROR: file not found: {customproperties}",)
    raise
  ditamap_directory = first_ditamap.parts[-2]  # 2nd-last element, assuming it's not in authoring or localization!!
  ditamap_id = ditamap_directory.split('.')[0].split('_')[0]  # substring before _ and .
  version = cptree.find('version').text
  version_appendix = urllib.parse.quote_plus(version)
  return f"{ditamap_id}.ditamap_{version_appendix}"


def get_new_filename(path):
  # old: vqg1523273567217_00003.xml
  # new: vqg1523273567217_202212131553_003.xml
  customproperties = path.with_suffix('.customproperties')
  try:
    cptree = ET.parse(str(customproperties))
  except Exception as e:
    e.args = ("ERROR: file not found: {customproperties}",)
    raise
  authoring_revision = cptree.find('authoringRevision').text.zfill(3)  # 0-padded to sort!
  file_id = path.stem.split('_')[0]  # substring before _ (or whole stem if no _)
  return f"{file_id}_{MIGRATION_TIMESTAMP}_{authoring_revision}{path.suffix}"


# Initialize the progress bar
total_file_count = 0
print("Counting files...")
for suffix in ['xml', 'ditamap', 'image', 'res']:
  for path in pathlib.Path('.').rglob(f"*.{suffix}"):
    total_file_count += 1
print(f"Total number of files: {total_file_count}")
pbar = tqdm(total=total_file_count)

# Initialize the XSLT processor
saxon_proc = PySaxonProcessor(license=False)
print(saxon_proc.version)
print(f"(tested config: saxonche version 12 (saxon/c) with saxon 9.9)")
#saxon_proc.set_cwd(str(pathlib.Path.cwd()))
saxon_proc.set_catalog("catalog-wsl.xml")
xslt_proc = saxon_proc.new_xslt30_processor()
xslt_proc_map = xslt_proc.compile_stylesheet(stylesheet_file="migrate_dita_map.xslt")
xslt_proc_topic = xslt_proc.compile_stylesheet(stylesheet_file="migrate_dita_topic.xslt")

def process(files, extra_strings=[]):
  # Iterate all files 
  # The list 'files' contains all files in a single map and is used to
  # search-and-replace references, which are normally only inside a map,
  # with the exception of supermaps, which refer to published maps, so
  # to search-and-replace these references, a list 'extra-strings' is provided.
  #
  # The contents of the XML files is processed in two steps:
  #
  #  1. the references to 

  for old_path, old_name, new_path, new_name in files:
    new_abs_path = new_path
    pathlib.Path(new_abs_path).mkdir(parents=True, exist_ok=True)
    old_file = '/'.join([old_path, old_name])
    new_file = '/'.join([new_abs_path, new_name])
    # New file already exists (from previous migration run)
    if pathlib.Path(new_file).exists():
      pass
    # Images: copy file and filename is changed from .image to .svg
    elif pathlib.Path(old_name).suffix == '.image':
      new_file = pathlib.Path(new_file).with_suffix('.svg')
      with open(old_file, 'rb') as old, open(new_file, 'wb') as new:
        new.write(old.read())
    # Resources: copy file and filename is changed from .res to .zip 
    # (otherwise oXygen Author won't recognize it as a zip)
    elif pathlib.Path(old_name).suffix == '.res':
      new_file = pathlib.Path(new_file).with_suffix('.zip')
      with open(old_file, 'rb') as old, open(new_file, 'wb') as new:
        new.write(old.read())
    # DITA maps
    elif pathlib.Path(old_name).suffix == '.ditamap':
      tmp_file = old_file + "_buffer.tmp"
      # 1. search and replace references to files
      with open(old_file, 'r') as old, open(tmp_file, 'w') as tmp:
        for old_line in old:
          new_line = old_line
          # find and replace filenames
          for _, old_string, _, new_string in files:
            new_line = new_line.replace(old_string, new_string)
          # find and replace full paths in supermaps
          # (extra_strings are collected in published and applied in authoring)
          for old_string1, old_string2, new_string1, new_string2 in extra_strings:
            new_line = new_line.replace(
              '/'.join([old_string1, old_string2]),
              '/'.join([new_string1, new_string2])
            )
          tmp.write(new_line)
      # 2. remove @ixia_locid and rename references to resources from .res to .zip
      # (this needs the system folder with DTD specs in place!)
      xslt_proc_map.transform_to_file(source_file=tmp_file, output_file=new_file)
      pathlib.Path(tmp_file).unlink()
    # topic files
    else:
      tmp_file = old_file + "_buffer.tmp"
      # 1. search and replace references to files
      with open(old_file, 'r') as old, open(tmp_file, 'w') as tmp:
        for old_line in old:
          new_line = old_line
          # find and replace filenames
          for _, old_string, _, new_string in files:
            new_line = new_line.replace(old_string, new_string)
          tmp.write(new_line)
      # 2. remove @ixia_locid and rename references to resources from .res to .zip
      # and references to images for .image to .svg
      # (this needs the system folder with DTD specs in place!)
      xslt_proc_topic.transform_to_file(source_file=tmp_file, output_file=new_file)
      pathlib.Path(tmp_file).unlink()
    pbar.update(1)

  tqdm.write(f"DONE: {len(files)} files in {directory}")


##########
## MAIN ##
##########

# Process the files in the PUBLISHED folder
published_ditamaps = []
for published_directory in pathlib.Path(sys.argv[1], 'published').glob('*/*/'):
  # e.g. '<export-dir>/published/fr-fr/<map-id>.ditamap_<revision>'
  if 'system' in published_directory.parts: continue  # ignore system dir (contains dtd files)
  try:
    ditamaps = list(pathlib.Path(published_directory).glob('*.ditamap'))
    first_ditamap = ditamaps[0]
    if len(ditamaps) > 1:
      tqdm.write(f"WARNING: more than 1 ditamap in {published_directory.as_posix()}") 
  except: 
    tqdm.write(f"ERROR: no ditamap in {published_directory.as_posix()}")
    # note: this should not happen on full exports!
    continue
  try:
    new_ditamap_directory = get_new_ditamap_directory_for_published(first_ditamap)
  except: continue
  # Iterate all files and collect old and new filenames in 'files' 
  files = []
  for suffix in ['*.xml', '*.ditamap', '*.image', '*.res']:
    for path in pathlib.Path(published_directory).glob(suffix):
      try:
        new_filename = get_new_filename(path)
      except: continue
      files.append((
        str(path.parent),  # old path 
        str(path.name),  # old name 
        '/'.join([path.parts[0], path.parts[1], new_ditamap_directory]),  # new path
        new_filename  # new name
      ))
      # collect extra strings that will be applied to supermaps in authoring
      if path.suffix == '.ditamap':
        published_ditamaps.append(files[-1])
  process(files)


# Process the files in the LOCALIZATION folder
for localization_directory in pathlib.Path(sys.argv[1], 'localization').glob('**/'):
  files = []
  if 'system' in localization_directory.parts: continue
  # Iterate all files and collect old and new filenames in 'files' 
  for suffix in ['*.xml', '*.ditamap', '*.image', '*.res']:
    for path in pathlib.Path(localization_directory).glob(suffix):
      try:
        new_filename = get_new_filename(path)
      except: continue
      files.append((
        str(path.parent),  # old path
        str(path.name),  # old name
        str(path.parent),  # new path
        new_filename  # new name
      ))
  process(files)


# Process the files in the AUTHORING folder
files = []
# Iterate all files and collect old and new filenames in 'files' 
for suffix in ['*.xml', '*.ditamap', '*.image', '*.res']:
  for path in pathlib.Path(sys.argv[1], 'authoring').glob(suffix):
    files.append((
      str(path.parent),  # old path
      str(path.name),  # old name
      str(path.parent),  # new path
      str(path.name)  # new name
    ))
process(files, extra_strings=published_ditamaps)


pbar.close()
