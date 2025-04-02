#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Listing all shell scripts in: $SCRIPT_DIR"
echo "----------------------------------------"

# Find all .sh files in the script directory
count=0
for script in "$SCRIPT_DIR"/*.sh; do
    # Skip if no files found
    if [ ! -f "$script" ]; then
        echo "No shell scripts found in this directory."
        exit 0
    fi
    
    # Get file name without path
    script_name=$(basename "$script")
    
    # Get file size
    size=$(du -h "$script" | cut -f1)
    
    # Get last modification time
    mod_time=$(stat -c '%y' "$script" 2>/dev/null || stat -f '%Sm' "$script" 2>/dev/null)
    
    # Check if file is executable
    if [ -x "$script" ]; then
        permissions="Executable"
    else
        permissions="Not executable"
    fi
    
    # Print information about the script
    echo "[$((++count))] $script_name"
    echo "    Size: $size"
    echo "    Modified: $mod_time"
    echo "    Permissions: $permissions"
    echo ""
done

echo "Total shell scripts: $count" 