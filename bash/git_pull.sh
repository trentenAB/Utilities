#!/bin/bash
set -e

trap 'echo "Error occurred at line $LINENO: $BASH_COMMAND"' ERR

# Usage: ./script.sh <owner> <group>
# Ensure two arguments are provided
# if [ "$#" -ne 2 ]; then
#     echo "Usage: $0 <owner> <group>"
#     exit 1
# fi

# Set default owner and group if not provided
OWNER=${1:-test}
GROUP=${2:-test}

# Run git pull and capture the output
OUTPUT=$(git pull)

printf "%s\n" "$OUTPUT"
echo ''

# GET TOP LEVEL OF REPO
TOP_LEVEL=$(git rev-parse --show-toplevel)

UPDATED_FILES=$(printf "%s\n" "$OUTPUT" | grep -oE '\s?([0-9a-zA-Z_\-\/]+\.\w{1,6})' | sort -u | awk '{$1=$1}1')
# 1. printf "%s\n" "$OUTPUT"
# Purpose: Converts the variable $OUTPUT into a newline-separated string.
# Why: Ensures that any special formatting or spacing in $OUTPUT is standardized into individual lines.
# 2. grep -oE '\s?([0-9a-zA-Z_\-/]+\.\w{1,6})'
# Purpose: Extracts file paths from the git output using a regular expression.
# Explanation of Regex:
# \s? → Matches 0 or 1 whitespace characters
# ([0-9a-zA-Z_\-/]+) → Captures a sequence of characters including digits, letters, underscores, hyphens, and slashes (directory separators).
# \. → Matches a literal period (dot before the file extension).
# \w{1,6} → Matches the file extension (1 to 6 word characters, such as .sh, .txt, .js).
# 3. sort -u
# Purpose: Sorts the list of file paths alphabetically and removes duplicates.
# -u Flag: Ensures that only unique lines are included.
# 4. awk '{$1=$1}1'
# In awk, $1 represents the first field (the first word) of the current line.
# By setting $1 to $1 (essentially assigning the value of the first field to itself), 
# awk triggers a re-evaluation of the entire line. 
# This forces awk to rebuild the line by concatenating the fields with the default output 
# field separator (which is a single space).
# Importantly, this step automatically trims leading and trailing whitespace from the line, 
# because awk strips out the leading/trailing spaces when reassembling the fields.
# The last 1 is a shorthand for a true condition in awk. 
# In awk, any condition that evaluates to true triggers the action following it (or the default action, which is to print the line).
# So, 1 means "always true," and thus awk will print each modified line.

# Use an associative array to track unique directories
# -A declares an associative array (key-value pairs)
declare -A DIRS_CHANGED

printf "\e[33mPERMISSION UPDATES******************\e[0m\n"
# Process each updated file
for FILE in $UPDATED_FILES; do
    # [ -e "$FILE" ] checks if the file or directory exists
    # -e means "exists" and returns true if the file/directory exists
    # Wrapping "$FILE" in quotes handles filenames with spaces or special characters
    if [ -e "$FILE" ]; then
        # Get the directory of the file
        DIR=$(dirname "$FILE")
        # Only change permissions if the directory hasn't been processed
        # ${DIRS_CHANGED[$DIR]} = Accesses the value stored in the associative array DIRS_CHANGED at the key $DIR.
        # Since DIRS_CHANGED is declared as an associative array (declare -A DIRS_CHANGED), each key represents a directory, and the value is typically used as a flag or indicator.
        # -z = This is a Bash test operator that checks if a string is empty.
        # Returns true if the string is empty (i.e., zero-length), and false otherwise.
        if [ -z "${DIRS_CHANGED[$DIR]}" ]; then
            # Change ownership and group recursively
            sudo chown -R "$OWNER":"$GROUP" "$DIR"
            # Change permissions
            sudo chmod 770 "$DIR"
            # \e[31m → Red
            # \e[32m → Green
            # \e[33m → Yellow
            # \e[34m → Blue
	    # \e[0m  → Default
            printf "DIRECTORY: \e[32m$DIR\e[0m ; Set -Recursive OWNER: \e[34m$OWNER\e[0m, -Recursive GROUP: \e[34m$GROUP\e[0m, PERMISSIONS: \e[34m770\e[0m\n"
            # Store directory as key with value 1 (for uniqueness)
            DIRS_CHANGED["$DIR"]=1
        fi
        
        if [ -f "$FILE" ]; then
            # Check if it's a file ending in .sh
            if [[ "$FILE" == *.sh ]]; then
                # Set permissions for .sh files
                sudo chmod 700 "$FILE"
                printf "FILE: \e[32m$FILE\e[0m ; Set PERMISSIONS: \e[34m700\e[0m\n"
            else
                # Set permissions for other files
                sudo chmod 600 "$FILE"
                printf "FILE: \e[32m$FILE\e[0m ; Set PERMISSIONS: \e[34m600\e[0m\n"
            fi
        fi
    fi
done
# file checks could include:
# -f (regular file), -d (directory), -s (non-empty file), -r (readable), -w (writable), -x (executable)

# Output directories that had permissions changed
# ${#DIRS_CHANGED[@]} counts the number of keys in the associative array
if [ ${#DIRS_CHANGED[@]} -eq 0 ]; then
    echo "No directories had permissions changed."
else
    echo ''
    printf "\e[33mRunning fapolicy on \e[31m$TOP_LEVEL\e[33m******************\e[0m\n"
#############INSERT FAPOLICY SCRIPTS HERE#####################

fi

# git config --global --add safe.directory $TOP_LEVEL

# - ${#DIRS_CHANGED[@]}: Number of elements (keys) in array
# - ${!DIRS_CHANGED[@]}: All keys in the array
# - ${DIRS_CHANGED[@]}: All values in the array
