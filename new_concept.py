#!/usr/bin/python3

# Run in WSL in /mnt/c/mcmsm as:
# 
#    python3 new_concept.py

from datetime import datetime
import pathlib
import random
import re
import string
import subprocess

# Create a topic id in the form abc230901154500
TIMESTAMP = datetime.today().strftime('%Y%m%d%H%M%S%f')[2:15]
MNEM = ""
for i in range(3):
  MNEM += random.choice(string.ascii_lowercase)
TOPIC_ID = MNEM + TIMESTAMP

template = "templates/concept.xml"
topic = f"authoring/{MNEM}{TIMESTAMP}.xml"

with open(template, 'r') as te, open(topic, 'w') as to:
  for line in te:
    # find and replace id
    line = line.replace("TOPIC_ID", TOPIC_ID)
    to.write(line)

windows_cwd = re.sub(r"^/mnt/(.)", r"\1:", str(pathlib.Path.cwd()))
full_path = pathlib.PureWindowsPath(windows_cwd).joinpath(topic)
subprocess.run(["/mnt/c/Program Files/Oxygen XML Author 23/oxygenAuthor23.1.exe", full_path])
print(full_path)
