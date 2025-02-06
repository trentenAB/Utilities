# exit script on error
set -e

# set usage threshold for notification
usage_threshold=$1

# exclude file-systems we don't care about by using the mounted on field
exclude_mounts="mnt\/wsl"

# df -h is the output to parse
# cut -d'%' cuts each line at delimeter ('%') and returns the first half (-f1)
# awk -v usage_threshold="$usage_threshold" passes the usage_threshold variable into awk as usage_threshold
# $5>=usage_threshold checks if 5th column (Use%) is greater than or equal to usage_threshold
# && ! /'"$exclude_mounts"'/ adds another condition, which in this case is to exclude lines that contain the string in exclude_mounts
# /'"$exclude_mounts"'/: The value of exclude_mounts is interpolated inside the regular expression by using '"$exclude_mounts"'. 
# This ensures that the content of the variable is used in the pattern
# {print NR} returns only the line numbers where conditions are met
# sending the stderr (2) to /dev/null suppresses the awk warning
# save the output of command into variable: line_nums 
line_nums=$(df -h|cut -d'%' -f1|awk -v usage_threshold="$usage_threshold" -v exclude_mounts="$exclude_mounts" '($5>=usage_threshold && ! /'"$exclude_mounts"'/) {print NR}' 2>/dev/null)

# the hashtag in front of the variable gives us how many characters the variable contains
# we save the number of characters to the size variable 
size=${#line_nums}

# these variables produce the number of characters in the first line (header) of "df -h"
# use this in the print_header function which prints "*" times the header_size
# this was only for fun and adds little value
header=$(df -h|awk 'NR==1')
header_size=${#header}

print_header() {
    printf '*%.0s' $(seq $header_size)
    # yes prints to screen indefinitely. But piped with head, only prints the number (-n) specified
    # so all this does is act as line breaks
    # number of "line breaks" is determined by the first argument ($1) passed
    yes ''|head -n $1
}

# if size greater than 1, then there is atleast 1 line we care about that meets the conditions 
# i.e. usage greater than or equal to usage_threshold and file system is something we care about
# note: size will always be atleast 1 because the header line always meets the conditions
# the header only contains alphabetic characters so numerical comparisions don't work the same way
if [ $size -gt 1 ]; then
    # >&2 prints the output to stderr instead of stdout
    printf '%s\n' "Usage at or above: $usage_threshold%!" >&2
    print_header 2
    # for each number in the line_nums variable display the line number in df -h equal to num
    for num in $line_nums;
    do
        # eval executes a string as a command
        eval "df -h |awk 'NR==$num'"
    done
    # exits the script with a positive error
    # since script "fails", a notification will be sent
    exit 1
fi

# if usage is not greater than or equal to usage_threshold, just print usage of import file systems to screen
echo "Usage under $usage_threshold%"
print_header 2
df -h|awk -v exclude_mounts="$exclude_mounts" '! /'"$exclude_mounts"'/' 2>/dev/null