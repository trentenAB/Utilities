set -e
# cat git_pull_output.txt |grep -E '\|'
cat git_pull_output.txt |grep -En 'changed' | cut -d' ' -f1-2 | cut -d':' -f 1,2
