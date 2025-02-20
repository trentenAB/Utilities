set -e
# # cat git_pull_output.txt |grep -E '\|'

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
# NUM_FILES=$(cat git_pull_output.txt |grep -E 'file' | cut -d 'f' -f 1 | awk '{$1=$1}1')

# FILES=$(cat git_pull_output.txt | grep -oE '\s?([0-9a-zA-Z_\-\/]+\.\w{1,6})' | sort -u | awk '{$1=$1}1')
FILES=$(cat text/output.txt | grep -oE '\s?([0-9a-zA-Z_\-\/]+\.\w{1,6})' | sort -u | awk '{$1=$1}1')
cat text/output.txt | grep -oE '\s?([0-9a-zA-Z_\-\/]+\.\w{1,6})' | sort -u | awk '{$1=$1}1'
# cat git_pull_output.txt | grep -oE '[^ ]+$'