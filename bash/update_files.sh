#!/bin/bash

#file="$1": Assigns the current file name to a variable for readability.
#ext="${file##*.}": Extracts the file extension (everything after the last .).
#base="${file%.*}": Extracts the base file name (everything before the last .).
#sed "s/.../..." "$file": Replaces hc.db.create_engine with hc.db.create_engine.
#> "${base}_.$ext": Appends an underscore (_) before the file extension and redirects the updated content to the new file

find . -type f -exec sh -c 'file="$1"; ext="${file##*.}"; base="${file%.*}"; sed "s/hc\.db\.create_odbc_engine/hc.db.create_engine/g" "$file" > "${base}_.$ext"' _ {} \;
