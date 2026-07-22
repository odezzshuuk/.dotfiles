#!/bin/bash

# Rename files in a directory with number sequence
# Usage: ./rename.sh [-d directory|--dir directory] [starting_number]

# Default values
START=1
DIRECTORY="."

usage() {
    echo "Description: This script renames files in a specified directory by adding a sequential number."
    echo "Usage: $0 [-d directory|--dir directory] [starting_number]"
}

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

# Check if starting number is provided
if [ -n "$1" ]; then
    START="$1"
fi

# Counter
count=$START

# Loop through all files in current directory
for file in *; do
    # Skip directories
    if [ -f "$file" ]; then
        # Get file extension
        extension="${file##*.}"
        
        # If file has no extension, keep it empty
        if [ "$extension" = "$file" ]; then
            extension=""
        else
            extension=".$extension"
        fi
        
        # Construct new filename with padded number (4 digits)
        new_name=$(printf "%s%04d%s" "$count" "$extension")
        
        # Rename the file
        echo "Renaming: $file -> $new_name"
        mv "$file" "$new_name"
        
        # Increment counter
        ((count++))
    fi
done

echo "Done! Renamed $((count - START)) files. Skipped .sh files."
