# can also use grep '^pattern' to match things at beginning of line
# -f1- will get field 1-> and beyond
# -d defines the delimiter
df -h|awk '{print $1, $5}' | cut -d' ' -f1-
