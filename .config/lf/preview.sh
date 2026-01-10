#!/bin/sh

# lf - File Manager Preview Script
#
# This script provides file previews for lf.
#
# Dependencies:
# - chafa: For image previews in the terminal.
# - bat: (Optional) For syntax-highlighted text previews.
# - pdftotext: For PDF text previews (from poppler-utils).
# - bsdtar: For listing contents of archive files.
# - mediainfo: For displaying media file metadata.

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# File path is the first argument
FILE_PATH="$1"
# Preview pane dimensions (optional, lf sets $WIDTH and $HEIGHT)
PREVIEW_WIDTH="$2"

# Get the MIME type of the file
MIME_TYPE=$(file --dereference --brief --mime-type -- "$FILE_PATH")

# --- Preview Logic ---

# 1. Handle directories
if [ -d "$FILE_PATH" ]; then
    # Use ls to show directory contents. You can replace with `eza`, `lsd`, etc.
    ls -lA --color=always -- "$FILE_PATH"
    exit 0
fi

# 2. Handle files based on MIME type
case "$MIME_TYPE" in
    # --- Text-based files ---
    text/* | application/json | application/xml | application/javascript | application/x-shellscript)
        # Use 'bat' for syntax highlighting if available, otherwise fall back to 'cat'.
        if command -v bat >/dev/null; then
            bat --color=always --paging=never --style=numbers,changes --terminal-width="$PREVIEW_WIDTH" -- "$FILE_PATH"
        else
            cat -- "$FILE_PATH"
        fi
        ;;

    # --- Image files ---
    image/*)
        # Use chafa to display the image in the terminal.
        # The size is adjusted to fit the preview pane's width.
        chafa --size "${PREVIEW_WIDTH}x" --animate off --polite on -- "$FILE_PATH"
        ;;

    # --- PDF documents ---
    application/pdf)
        # Extract text from PDF and display it.
        pdftotext -l 5 -nopgbrk -q -- "$FILE_PATH" - | head -n 100
        ;;

    # --- Archive files ---
    application/zip | application/x-rar | application/x-tar | application/x-7z-compressed | application/gzip | application/x-bzip2)
        # List the contents of the archive using bsdtar.
        bsdtar -tf "$FILE_PATH"
        ;;

    # --- Video and Audio files ---
    video/* | audio/*)
        # Show media file information.
        mediainfo "$FILE_PATH"
        ;;

    # --- Fallback for other file types ---
    *)
        # Display basic file information.
        file --dereference --brief -- "$FILE_PATH"
        ;;
esac

exit 0
