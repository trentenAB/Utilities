#!/bin/bash

# Remove all files in current directory and all subdirectories that that start with "file" in its name

# find .: Searches in the current directory and its subdirectories.
# -type f: Limits the search to files only.
# -name "file*": Matches files whose names start with "file".
# -exec rm -f {} +: Removes the matched files. The + ensures efficient batch processing of files

find . -type f -name "file*" -exec rm -f {} +
