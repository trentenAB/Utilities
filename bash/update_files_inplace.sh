#!/bin/bash

#find .: Searches the current directory (.) recursively.
#-type f: Limits the search to files.
#-exec: Executes the specified command on each file found.
#sed -i: Edits files in place.
#'s/hc\.db\.create_odbc_engine/hc.db.create_engine/g': The sed substitution command replaces all occurrences (g flag) of the string in each file. Note the backslashes (\) to escape the dots (.) in the pattern.
#{}: A placeholder that find replaces with each file name.
#+: Optimizes the command by processing multiple files at once.


find . -type f -exec sed -i 's/hc\.db\.create_odbc_engine/hc.db.create_engine/g' {} +
