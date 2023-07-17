#!/usr/bin/python3

# This script migrates the exported IXIASOFT CMS files from an export folder
# (containing 'published', 'localization' and 'authoring' folders), into the current CMS folder.
#
# Prerequisite: the 'system' folder, containing IXIASOFT DTD files, must be copied into
# '<export-dir>/published/system' and '<export-dir>/../system'.
#
# When using the export that is made for Output Generation, start from the zip-file, because
# the extracted files are pre-processed! (e.g. .image renamed to .svg)
#
# Run in WSL in the current CMS folder as:
#
#   python3 migrate.py <export-dir>
#
# All files are copied 1-1, but the names are changed:
#
#  - published folders are renamed to <map_id>.ditamap_<version>
#    where <version> is the uri-encoded version string, with space -> '+',
#    and the encoding hidden for XSLT's doc() function by replacing '%' by '~'
#  - published and localization files are renamed to 
#    <id>_<migration_timestamp>_<authoring_revision>
#
# The migration timestamp will be part of the filenames in published and localization.
# The authoring revision will be added as well.
# When in operation, the CMSM will use the authoring timestamp (file attribute) instead

# Set OVERWRITE flag True to redo migration for files that are already migrated
OVERWRITE = True

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

#MIGRATION_TIMESTAMP = datetime.today().strftime('%Y%m%d%H%M')
# Using a hardcoded timestamp allows to have subsequent runs of the migration without
# duplicating files
MIGRATION_TIMESTAMP = "202307141139"


def get_new_ditamap_dirname_for_published(master_ditamap):
  # master_ditamap:
  # - '<export-dir>/published/en-us/<map-id>.ditamap_<revision>/<map_id>.ditamap'
  # - '<export-dir>/published/fr-fr/<map-id>_<map_revision>.ditamap_<localization_revision>/<map-id>_<map_revision>.ditamap'
  # new ditamap dirname: '<map-id>.ditamap_<version(url-encoded)>'
  customproperties = master_ditamap.with_suffix('.customproperties')
  try:
    cptree = ET.parse(str(customproperties))
  except Exception as e:
    e.args = ("ERROR: file not found: {customproperties}",)
    raise
  version = cptree.find('version').text.strip()
  version_appendix = urllib.parse.quote_plus(version).replace('%','~')
  ditamap_id = master_ditamap.stem.split('_')[0] 
  return f"{ditamap_id}.ditamap_{version_appendix}"


def get_new_filename(path):
  # path e.g. "<export-dir>/published/en-us/<map-id>.ditamap_<revision>/<id>.xml"
  # new filename: "<id>_<MIGRATION_TIMESTAMP>_<authoring_revision>.xml"
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
for directory in ['authoring', 'localization', 'published']:
  for suffix in ['xml', 'ditamap', 'image', 'res']:
    for path in pathlib.Path(sys.argv[1], directory).rglob(f"*.{suffix}"):
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
  # Iterate files, a list of tuples (<old-path>, <old-filename>, <new-path>, <new-filename>) 
  # 
  # The list contains all files in a single map and is used to convert files 1-on-1.
  #
  # The list is also used to perform a global search-and-replace on
  # references to the files, which are normally only inside a map,
  # with the exception of supermaps, which refer to published maps, so
  # to search-and-replace these references, a list 'extra-strings' is provided.

  for old_path, old_name, new_path, new_name in files:
    new_abs_path = new_path
    pathlib.Path(new_abs_path).mkdir(parents=True, exist_ok=True)
    old_file = '/'.join([old_path, old_name])
    new_file = '/'.join([new_abs_path, new_name])

    # New file already exists (from previous migration run)
    if pathlib.Path(new_file).exists() and not OVERWRITE:
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
          for old_string, new_string in extra_strings:
            new_line = new_line.replace(old_string, new_string)
            tqdm.write(f"DEBUG: s&r {str(old_string)[-100:]} => {str(new_string)[-100:]}")
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
    tqdm.write(f"DEBUG: mig {str(old_file)[-100:]} => {str(new_file)[-100:]}")
    pbar.update(1)

  tqdm.write(f"DONE: {len(files)} files in {directory}")


##########
## MAIN ##
##########

# Process the files in the PUBLISHED folder
# Files here are
# - maps and dependent topics, localized and published and linked from a Supermap
# - topics or images without maps, linked from a branched authoring map
published_ditamaps = []
for published_directory in pathlib.Path(sys.argv[1], 'published').glob('*/*/'):

  # published_directory e.g.
  # - "<export-dir>/published/en-us/<map-id>.ditamap_<revision>"
  # - "<export-dir>/published/fr-fr/<map-id>_<map_revision>.ditamap_<localization_revision>"

  # Ignore system dir (contains dtd files)
  if 'system' in published_directory.parts: continue  

  # Find master ditamap
  master_ditamap_filename = published_directory.with_suffix('.ditamap').name
  master_ditamap = pathlib.Path(published_directory, master_ditamap_filename)
  if not master_ditamap.exists():
    tqdm.write(f"ERROR finding master ditamap; {published_directory.as_posix()} contains topics for branched ditamaps; not supported for migration")
    continue
  else:
    # Compose new ditamap dir name
    try:
      new_ditamap_dirname = get_new_ditamap_dirname_for_published(master_ditamap)
    except: 
      tqdm.write(f"ERROR composing new ditamap dir name; SKIPPING {published_directory.as_posix()}")
      continue

  # Iterate all files and collect old and new filenames in 'files' 
  language = published_directory.parts[-2]
  files = []

  for suffix in ['*.xml', '*.ditamap', '*.image']:
    for path in pathlib.Path(published_directory).glob(suffix):
      # path e.g. "<export-dir>/published/en-us/<map-id>.ditamap_<revision>/<id>.xml"
      try:
        new_filename = get_new_filename(path)
      except: 
        tqdm.write(f"ERROR composing new filename; SKIPPING {path.as_posix()}")
        continue
      files.append((
        str(published_directory),  # old path
        str(path.name),   # old filename
        str(pathlib.Path('published', language, new_ditamap_dirname)),  # new path
        new_filename  # new name
      ))
      # collect extra strings that will be applied to (super)maps in authoring
      if suffix == '.ditamap':
        old_string = str(pathlib.Path(published_directory.name, path.name))
        new_string = str(pathlib.Path(new_ditamap_dirname, new_filename))
        ''' OBSOLETE: urlencode is hidden by replacing % by ~
        new_string = str(pathlib.Path(urllib.parse.quote_plus(new_ditamap_dirname), new_filename))
        # the new_ditamap_dirname may contain URI-encoded characters;
        # these must be DOUBLE encoded when used has href in a ditamap file,
        # because oXygen Author and Saxon XSLT will DECODE the href first,
        # before going to the filesystem.
        '''
        published_ditamaps.append((old_string, new_string))

  process(files)


# Process the files in the LOCALIZATION folder
for localization_directory in pathlib.Path(sys.argv[1], 'localization').glob('**/'):

  # Ignore system dir (contains dtd files)
  if 'system' in localization_directory.parts: continue

  # Iterate all files and collect old and new filenames in 'files' 
  language = localization_directory.parts[-1]
  files = []

  for suffix in ['*.xml', '*.ditamap', '*.image', '*.res']:
    for path in pathlib.Path(localization_directory).glob(suffix):
      try:
        new_filename = get_new_filename(path)
      except: continue
      files.append((
        str(localization_directory),  # old path
        str(path.name),  # old name
        str(pathlib.Path('localization', language)),  # new path
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
      str(pathlib.Path('authoring')),  # new path
      str(path.name)  # new name
    ))

process(files, extra_strings=published_ditamaps)


pbar.close()
