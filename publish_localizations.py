#!/usr/bin/python3
import click
import pathlib
import sys
import stat
from tqdm import tqdm

# Run in WSL in /mnt/c/mcmsm as:
#
#   python3 publish_localizations.py published/en-us/<map_id>.ditamap_<version>
#
# A list of target languages is obtained interactively.
#
# For each language and each file in the published folder, the corresponding file in:
#
#   localization/<language>
# 
# is copied to:
#
#   published/<language>/<map_id>.ditamap_<version>

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

for published_file in published_files:

  for language in languages:

    pbar.update(1)

    # Set target filename and create missing dirs
    localization_dir = pathlib.Path("localization", language)
    pathlib.Path(localization_dir).mkdir(parents=True, exist_ok=True)
    localization_file = localization_dir.joinpath(published_file.name)
    kit_dir = pathlib.Path("kit", language)
    kit_file = kit_dir.joinpath(published_file.name)
    published_localization_dir = pathlib.Path(sys.argv[1].replace('en-us',language))
    pathlib.Path(published_localization_dir).mkdir(parents=True, exist_ok=True)
    published_localization_file = published_localization_dir.joinpath(published_file.name)

    # Assertions
    if kit_file.exists():
      tqdm.write(f"ERROR: file cannot be published, it is still in translation kit {kit_file}")

    elif not localization_file.exists():
      tqdm.write(f"ERROR: translated file not found {localization_file}")

    else:
      # Copy the file from localization/<lang> to published/<lang>/<map_id>.ditamap_<version>
      published_localization_file.write_bytes(localization_file.read_bytes())  # copy file

      # Make the published file read-only
      published_localization_file.chmod(stat.S_IREAD)

      tqdm.write(f"File published to {published_localization_file}")

pbar.close()

#import pdb; pdb.set_trace()



