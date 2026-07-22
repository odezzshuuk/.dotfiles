#!/bin/bash

# Add prefix to all files

DIRECTORY="."

usage() {
    cat << EOF
Description: 
    Adds prefix to all files in a given directory

Usage: 
    $(basename $0) [-d directory|--dir directory] prefix_text

Example: 
    $(basename $0) --dir photos backup_
EOF
exit 0
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--dir)
            if [ -z "$2" ]; then
                echo "Error: $1 requires a directory path." >&2
                usage >&2
                exit 1
            fi
            DIRECTORY="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done


if [ ! -d "$DIRECTORY" ]; then
    echo "Error: directory does not exist: $DIRECTORY" >&2
    exit 1
fi

cd "$DIRECTORY" || exit 1

for file in *; do
    # Skip .sh files and directories
    if [ -f "$file" ]; then
        mv "$file" "$1$file"
    fi
done

echo "Prefix '$1' added to all non-.sh files"
