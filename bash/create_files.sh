#!/bin/bash

# Number of files to create
num_files=10

# Create the files
for i in $(seq 1 $num_files); do
  echo -e "This is file $i.\nRandom text.\nhc.db.create_engine is here.\nMore random text." > "file_$i.txt"
done

echo "$num_files files created with at least one occurrence of 'hc.db.create_engine'."
