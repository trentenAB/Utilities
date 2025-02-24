#!/bin/bash
set -e

# PURPOSE: SHOW VERSATILITY OF BASH SCRIPTING

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 NUM[1-10]"
    exit 1
fi

if [[ $1 -lt 0 || $1 -gt 10 ]]; then
    echo "NUM between 1-10"
    exit 1
fi

NUM=$1

# PIPE EXPLANATION
# python3 run/main.py: 
    # print random number between 1 and 10, inclusive, 100 times
# cat -n: 
    # add line numbers to output
# ./run/awk.sh $NUM: 
    # pass argument passed to pipe.sh to awk.sh and print lines where column2=argument
python3 run/main.py | cat -n | ./run/awk.sh $NUM