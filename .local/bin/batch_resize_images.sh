#!/bin/bash

# Default values
TARGET_DIR="."
OUTPUT_DIR=""
OUTPUT_SIZE="64x64"
OVERWRITE=false
VERBOSE=false
KEEP_ORIGINAL=true

# Function to display usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Resize all .jpg and .png images in a directory to a specified size using ffmpeg.

OPTIONS:
    -d, --dir DIR         Target directory containing images (default: current directory)
    -o, --output DIR      Output directory for resized images (default: creates "resized" subfolder)
    -s, --size SIZE       Output size (default: 64x64)
    -f, --force           Force exact size (stretch images)
    -c, --crop            Crop to exact size (center crop)
    -a, --aspect          Preserve aspect ratio (fit within size, default)
    -y, --overwrite       Overwrite original files (use with caution!)
    -v, --verbose         Show verbose output
    -h, --help            Display this help message

EXAMPLES:
    $(basename $0) -d /path/to/images
    $(basename $0) --dir ./photos --output ./thumbnails --size 128x128
    $(basename $0) -d ./images -f -y    # Force size and overwrite originals
    $(basename $0) --dir ./pics --crop  # Center crop to exact size
EOF
    exit 0
}

# Require an explicit option to avoid accidentally processing the current directory.
if [[ $# -eq 0 ]]; then
    usage
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            TARGET_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -s|--size)
            OUTPUT_SIZE="$2"
            shift 2
            ;;
        -f|--force)
            RESIZE_MODE="force"
            shift
            ;;
        -c|--crop)
            RESIZE_MODE="crop"
            shift
            ;;
        -a|--aspect)
            RESIZE_MODE="aspect"
            shift
            ;;
        -y|--overwrite)
            OVERWRITE=true
            KEEP_ORIGINAL=false
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate target directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Set output directory
if [[ -z "$OUTPUT_DIR" ]]; then
    if [[ "$OVERWRITE" == true ]]; then
        OUTPUT_DIR="$TARGET_DIR"
    else
        OUTPUT_DIR="$TARGET_DIR/resized_$(date +%Y%m%d_%H%M%S)"
    fi
fi

# Create output directory if it doesn't exist
if [[ "$OUTPUT_DIR" != "$TARGET_DIR" ]] && [[ ! -d "$OUTPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR"
    if [[ "$VERBOSE" == true ]]; then
        echo "Created output directory: $OUTPUT_DIR"
    fi
fi

# Set resize filter based on mode
set_resize_filter() {
    case $RESIZE_MODE in
        force)
            echo "scale=$OUTPUT_SIZE:force_original_aspect_ratio=disable"
            ;;
        crop)
            # Crop to target size (center crop)
            WIDTH="${OUTPUT_SIZE%x*}"
            HEIGHT="${OUTPUT_SIZE#*x}"
            echo "crop=min(iw\\,$WIDTH):min(ih\\,$HEIGHT),scale=$OUTPUT_SIZE"
            ;;
        aspect|*)
            echo "scale=$OUTPUT_SIZE:force_original_aspect_ratio=decrease"
            ;;
    esac
}

FILTER=$(set_resize_filter)

# Count files
JPG_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | wc -l)
PNG_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.png" | wc -l)
TOTAL_FILES=$((JPG_COUNT + PNG_COUNT))

if [[ $TOTAL_FILES -eq 0 ]]; then
    echo "No .jpg or .png files found in '$TARGET_DIR'"
    exit 0
fi

echo "Found $TOTAL_FILES images to process"
echo "Resize mode: ${RESIZE_MODE:-aspect}"
echo "Output size: $OUTPUT_SIZE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Initialize counters
PROCESSED=0
FAILED=0

# Process the images
process_image() {
    local input_file="$1"
    local ext="${input_file##*.}"
    local filename=$(basename "$input_file")
    
    if [[ "$VERBOSE" == true ]]; then
        echo "Processing: $filename" >&2
    fi
    
    # Determine output path
    if [[ "$OUTPUT_DIR" == "$TARGET_DIR" ]] && [[ "$OVERWRITE" == true ]]; then
        # Overwrite original
        output_path="$input_file"
    else
        # Save to output directory
        if [[ "$KEEP_ORIGINAL" == true ]]; then
            # Add suffix to filename
            base="${filename%.*}"
            output_path="$OUTPUT_DIR/${base}_${OUTPUT_SIZE}.$ext"
        else
            output_path="$OUTPUT_DIR/$filename"
        fi
    fi
    
    # Check if output already exists
    if [[ -f "$output_path" ]] && [[ "$OVERWRITE" == false ]] && [[ "$output_path" != "$input_file" ]]; then
        if [[ "$VERBOSE" == true ]]; then
            echo "  Skipping $filename (output exists)" >&2
        fi
        return 0
    fi
    
    # Build ffmpeg command
    local cmd="ffmpeg -i \"$input_file\" -vf \"$FILTER\""
    
    # Add quality settings based on file type
    case "$ext" in
        jpg|jpeg)
            cmd="$cmd -q:v 2"
            ;;
        png)
            cmd="$cmd -compression_level 9"
            ;;
    esac
    
    cmd="$cmd -y \"$output_path\""
    
    # Execute command
    if [[ "$VERBOSE" == true ]]; then
        echo "  Running: $cmd" >&2
        eval $cmd 2>&1 | grep -E "(frame|size|time)" || true
    else
        eval $cmd 2>/dev/null
    fi
    
    if [[ $? -eq 0 ]] && [[ -f "$output_path" ]]; then
        echo "  ✓ $filename -> $(basename "$output_path")" >&2
        return 0
    else
        echo "  ✗ Failed: $filename" >&2
        return 1
    fi
}

# Process files - SIMPLE FIX: Use a for loop with find
process_files() {
    local ext_pattern="$1"
    local processed=0
    local failed=0
    
    # Use find to get files and loop directly (no subshell)
    while IFS= read -r -d '' file; do
        if process_image "$file"; then
            ((processed++))
        else
            ((failed++))
        fi
    done < <(find "$TARGET_DIR" -maxdepth 1 -type f -iname "$ext_pattern" -print0)
    
    # Return counts via global variables
    PROCESSED=$((PROCESSED + processed))
    FAILED=$((FAILED + failed))
}

# Process JPG files
if [[ $JPG_COUNT -gt 0 ]]; then
    echo "Processing JPEG files..."
    process_files "*.jpg"
    # Also process .jpeg
    process_files "*.jpeg"
fi

# Process PNG files
if [[ $PNG_COUNT -gt 0 ]]; then
    echo "Processing PNG files..."
    process_files "*.png"
fi

# Summary
echo ""
echo "========================================"
echo "Processing complete!"
echo "Total processed: $PROCESSED"
echo "Failed: $FAILED"
echo "Output directory: $OUTPUT_DIR"
echo "========================================"

# Show sample output
if [[ "$VERBOSE" == true ]] && [[ $PROCESSED -gt 0 ]]; then
    echo ""
    echo "Sample of resized files:"
    ls -lh "$OUTPUT_DIR" | head -6
fi

exit 0
