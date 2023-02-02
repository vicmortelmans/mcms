#!/usr/bin/python3
import pathlib
import subprocess
import sys
full_path = pathlib.PureWindowsPath("D:/mcmsm") / sys.argv[1]
subprocess.run(["/mnt/c/Program Files/Oxygen XML Author 23/oxygenAuthor23.1.exe", full_path])
