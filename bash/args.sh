#!/bin/bash
set -e 

print_buf(){
    buf=$(echo -n "Usage: " | wc -m)
    printf "%*s%s\n" "$buf" "" "$1"
}

print_sep(){
    sep=$(printf '*%.0s' $(seq $1))
    print_buf "$sep"
}

if [ "$#" -eq 0 ]; then
    header="Usage: $0 *args"
    echo $header
    print_buf "Shows uses of special argument character sequences"
    print_buf "Consider passing more arguements for testing"
    print_sep ${#header}
    print_sep ${#header}    
fi

print_buf "Number of arguments -> \$# = $#"
print_buf "All arguements -> \$@ = ${all_args:=$@}"
print_buf "Last argument -> \${!#} = ${last:=${!#}}"
print_buf "Last element of last argument -> \${*last_arg*: -1} = ${last: -1}"

