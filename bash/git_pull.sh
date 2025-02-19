#!/bin/bash
set -e

trap 'echo "Error occurred at line $LINENO: $BASH_COMMAND"' ERR
# Usage: ./script.sh <owner> <group>

# Ensure two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <owner> <group>"
    exit 1
fi

OWNER=$1
GROUP=$2

# Run git pull and capture the output
OUTPUT=$(git pull)

# Parse the output for updated directories
# Extract lines starting with '   ' that indicate file changes
UPDATED_FILES=$(echo "$OUTPUT" | grep -E '^   ' | awk '{print $2}')

# Use an associative array to track unique directories
# -A declares an associative array (key-value pairs)
declare -A DIRS_CHANGED

# Process each updated file
for FILE in $UPDATED_FILES; do
    # [ -e "$FILE" ] checks if the file or directory exists
    # -e means "exists" and returns true if the file/directory exists
    # Wrapping "$FILE" in quotes handles filenames with spaces or special characters
    if [ -e "$FILE" ]; then
        # Get the directory of the file
        DIR=$(dirname "$FILE")
        # Change ownership and group recursively
        sudo chown -R "$OWNER":"$GROUP" "$DIR"
        # Store directory as key with value 1 (for uniqueness)
        DIRS_CHANGED["$DIR"]=1
        
        # Check if it's a directory
        if [ -d "$FILE" ]; then
            # Set permissions for directories
            sudo chmod 770 "$FILE"
        elif [ -f "$FILE" ]; then
            # Check if it's a file ending in .sh
            if [[ "$FILE" == *.sh ]]; then
                # Set permissions for .sh files
                sudo chmod 700 "$FILE"
            else
                # Set permissions for other files
                sudo chmod 600 "$FILE"
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
    echo "Directories with permissions changed:"
    # ${!DIRS_CHANGED[@]} expands to all keys (directories) of the array
    for DIR in "${!DIRS_CHANGED[@]}"; do
        echo "$DIR"
    done
fi

# Explanation of key Bash syntax:
# - Associative array: declare -A DIRS_CHANGED
# - ${#DIRS_CHANGED[@]}: Number of elements (keys) in array
# - ${!DIRS_CHANGED[@]}: All keys in the array
# - ${DIRS_CHANGED[@]}: All values in the array
# - [ -e "$FILE" ]: File or directory exists
# - chown -R: Recursively change ownership and group
# - [ -d "$FILE" ]: Checks if it's a directory
# - [ -f "$FILE" ]: Checks if it's a regular file
# - chmod 770: Sets permissions for directories
# - chmod 700: Sets permissions for .sh files
# - chmod 600: Sets permissions for other files
