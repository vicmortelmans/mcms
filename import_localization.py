#!/usr/bin/python3
import pathlib
import sys
from tqdm import tqdm
from saxonche import PySaxonProcessor

# Run in WSL in /mnt/d/mcmsm as:
#
#   python3 import_localization.py <dir>
#
# <dir> is assumed to contain one folder per language and in each folder a set of
# translated DITA files.
#
# This script copies the dita files found in <dir> into this folder:
# 
#   localization/<language>
#
# The files are not renamed but processed through import_localization.xslt 
# to strip the "translate='...'" attributes.
# 
#   <id>_<authoring_timestamp>.*
#
# The link to this file is removed from
#
#    kit/<language>
#

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

# Collect all source files
print("Counting files...")
translated_files = []
for ext in ['*/*.xml', '*/*.ditamap']:
  translated_files.extend(pathlib.Path(sys.argv[1]).glob(ext))

# Initialize the progress bar
total_file_count = len(translated_files)
print(f"Total number of target files: {total_file_count}")
pbar = tqdm(total=total_file_count)

for translated_file in translated_files:

  pbar.update(1)

  language = translated_file.parts[-2]

  # Set target filename
  kit_dir = pathlib.Path("kit", language)
  kit_file = kit_dir.joinpath(translated_file.name)
  localization_dir = pathlib.Path("localization", language)
  localization_file = localization_dir.joinpath(translated_file.name)

  # Generate localization file without pretranslated content
  xslt_proc.transform_to_file(stylesheet_file="import_localization.xslt", 
    source_file=abspath(translated_file),
    output_file=abspath(localization_file))
  tqdm.write(f"DITA file imported: {localization_file}")

  # Delete link in kit/<language> 
  kit_file.unlink()

pbar.close()

#import pdb; pdb.set_trace()

