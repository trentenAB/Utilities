function mvp () {
    dir="${!#}" # Include a / at the end to indicate directory (not filename)
    [ "${dir: -1}" != "/" ] && dir="$(dirname "${!#}")"
    echo "dir=$dir"
    [ -e "$dir" ] || mkdir -p "$dir"
    mv "$@"
}

