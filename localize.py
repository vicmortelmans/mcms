#!/usr/bin/python3
import click
import pathlib
import sys
from tqdm import tqdm
from saxonche import PySaxonProcessor

# Run in WSL in /mnt/c/mcmsm as:
#
#   python3 localize.py published/en-us/<map_id>.ditamap_<version>
#
# A list of target languages is obtained interactively.
#
# This script copies the dita files found in the published folder into this folder:
# 
#   localization/<language>
#
# The files are not renamed but processed through localize.xslt or 
# localize_pretranslate.xslt to include pretranslated content (if available).
# 
#   <id>_<authoring_timestamp>.*
#
# If the target file already exists in localization/<language> then translation 
# is available (or ongoing) and nothing is done!
#
# A link to each target file is created in
#
#    kit/<language>
#
# The links in kit/<language> will be DELETED once the translations are received.
#
# This script copies the image files found in the published folder into this folder:
#
#    localization/<language>

# Aux function
def abspath(relpath):
  return str(pathlib.Path.cwd().joinpath(relpath).absolute())

# Initialize the XSLT processor
saxon_proc = PySaxonProcessor(license=False)
print(saxon_proc.version)
print(f"(tested config: saxonche version 12 (saxon/c) with saxon 9.9)")
#saxon_proc.set_cwd(str(pathlib.Path.cwd()))
saxon_proc.set_catalog("catalog-wsl.xml")
xslt_proc = saxon_proc.new_xslt30_processor()
xslt_exec_localize = xslt_proc.compile_stylesheet(stylesheet_file="localize.xslt")
xslt_exec_pretranslate = xslt_proc.compile_stylesheet(stylesheet_file="localize_pretranslate.xslt")

# Ask user for languages
LANGUAGES = """bg-bg
cs-cz
da-dk
de-de
el-gr
es-es
et-ee
fi-fi
fr-fr
hr-hr
hu-hu
it-it
ja-jp
ko-kr
lt-lt
lv-lv
nl-nl
nb-no
pl-pl
pt-br
pt-pt
ro-ro
ru-ru
sk-sk
sl-si
sv-se
th-th
tr-tr
vi-vn
zh-cn
zh-tw"""
languages = click.edit(LANGUAGES).splitlines()

# Collect all source files
print("Counting files...")
published_files = []
for ext in ['*.xml', '*.svg', '*.ditamap']:
  published_files.extend(pathlib.Path(sys.argv[1]).glob(ext))

# Initialize the progress bar
total_file_count = len(published_files) * len(languages)
print(f"Total number of target files: {total_file_count}")
pbar = tqdm(total=total_file_count)

# Initialize kit counter
kit_file_counter = 0

for published_file in published_files:

  for language in languages:

    pbar.update(1)

    # Set target filename and create missing dirs
    kit_dir = pathlib.Path("kit", language)
    pathlib.Path(kit_dir).mkdir(parents=True, exist_ok=True)
    kit_file = kit_dir.joinpath(published_file.name)
    localization_dir = pathlib.Path("localization", language)
    pathlib.Path(localization_dir).mkdir(parents=True, exist_ok=True)
    localization_file = localization_dir.joinpath(published_file.name)

    # Previous (pre-)translation of this same file is already in localization dir
    # (if there's still a link in kit/<language>, touch it!)
    if localization_file.exists(): 
      if kit_file.exists():
        kit_file.touch()
        kit_file_counter += 1
      tqdm.write(f"File already translated (or in translation): {localization_file}")
      continue

    # Images can be copied directly to localization dir
    if published_file.suffix == '.svg':
      localization_file.write_bytes(published_file.read_bytes())  # copy file
      tqdm.write(f"IMAGE file copied to {localization_file}")
      continue

    # Find translations of other versions of this file in localization/<language>
    file_id = published_file.stem.split('_')[0]
    localization_files = list(pathlib.Path("localization", language).glob(f"{file_id}*.*"))

    if len(localization_files) == 0:

      # Generate localization file without pretranslated content in localization dir
      xslt_exec_localize.set_parameter("language",  \
        saxon_proc.make_string_value(language))
      xslt_exec_localize.transform_to_file(source_file=abspath(published_file),
        output_file=abspath(localization_file))
      tqdm.write(f"DITA file was untranslated: {localization_file}")

    else:

      # Generate localization file with pretranslated content in localization dir
      most_recent_localization_file = max(localization_files, key=lambda f:f.name) 
      most_recent_localization_published_file = list(pathlib.Path("published", "en-us") \
       .glob(f"*/{most_recent_localization_file.name}"))[0]
      xslt_exec_pretranslate.set_parameter("language",  \
        saxon_proc.make_string_value(language))
      xslt_exec_pretranslate.set_parameter("old-publication",  \
        saxon_proc.make_string_value(  \
          abspath(most_recent_localization_published_file)))
      xslt_exec_pretranslate.set_parameter("old-translation",  \
        saxon_proc.make_string_value(  
          abspath(most_recent_localization_file)))
      xslt_exec_pretranslate.transform_to_file(source_file=abspath(published_file),
        output_file=abspath(localization_file))
      tqdm.write(f"DITA file pretranslated: {localization_file}; based on: {most_recent_localization_file}")
    
    # Create link in kit/<language> dir, collecting files for translators
    localization_file.link_to(kit_file)
    kit_file_counter += 1

tqdm.write(f"Total number of files in kit: {kit_file_counter}")
pbar.close()

#import pdb; pdb.set_trace()

