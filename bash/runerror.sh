error_handler(){
    echo error handling
    echo "Error found in: $(caller)" >&2
    exit 1
}

trap 'error_handler' ERR

ls /hello
echo hello

# main #|| error_handler