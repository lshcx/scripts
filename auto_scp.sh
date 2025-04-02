#!/bin/bash

# Default values
USER="root"
IP="192.168.1.101"
DELETE=false
SRC=""
DST=""
KEY_PATH="$HOME/.ssh/id_rsa"  # Default SSH key path
RESUME=false                  # Whether to use rsync partial transfer

# Function to display usage
function show_usage {
    echo "Usage: $0 -s/--src <source_path> -d/--dst <destination_path> [options]"
    echo "Options:"
    echo "  -s, --src <path>     : Source file or directory path (required)"
    echo "  -d, --dst <path>     : Destination path (required)"
    echo "  -u, --user <username>: Username (default: root)"
    echo "  --ip <address>       : IP address (default: 192.168.1.101)"
    echo "  --key <path>         : SSH private key path (default: $HOME/.ssh/id_rsa)"
    echo "  --rm                 : Delete source file/directory after transfer"
    echo "  --resume             : Enable resume transfer using rsync"
    echo "  -h, --help           : Display this help message"
    exit 1
}

# Parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        -s | --src )     shift
                         SRC=$1
                         ;;
        -d | --dst )     shift
                         DST=$1
                         ;;
        -u | --user )    shift
                         USER=$1
                         ;;
        --ip )           shift
                         IP=$1
                         ;;
        --key )          shift
                         KEY_PATH=$1
                         ;;
        --rm )           DELETE=true
                         ;;
        --resume )       RESUME=true
                         ;;
        -h | --help )    show_usage
                         ;;
        * )              show_usage
                         ;;
    esac
    shift
done

# Check required parameters
if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "Error: Source path and destination path are required parameters"
    show_usage
fi

# Check if key file exists
if [ ! -f "$KEY_PATH" ]; then
    echo "Error: SSH key file $KEY_PATH does not exist"
    exit 1
fi

# Start file transfer
echo "Starting file transfer..."

# Choose between scp and rsync based on resume transfer option
if [ "$RESUME" = true ]; then
    # Using rsync with resume capability
    RSYNC_OPTS="-r -P"  # -r for recursive, -P for partial and progress
    
    # Build SSH command for rsync
    SSH_CMD="ssh -i $KEY_PATH"
    
    # Fix path handling difference between scp and rsync
    # If source path ends with a slash, remove it to maintain scp-like behavior
    SRC_FOR_RSYNC="${SRC%/}"
    
    # Execute rsync command
    echo "Using rsync for resume transfer..."
    rsync $RSYNC_OPTS --rsh="$SSH_CMD" "$SRC_FOR_RSYNC" $USER@$IP:"$DST"
    TRANSFER_STATUS=$?
else
    # Using traditional scp
    echo "Using scp for file transfer..."
    scp -r -c aes192-ctr -i "$KEY_PATH" "$SRC" $USER@$IP:"$DST"
    TRANSFER_STATUS=$?
fi

# Check if the transfer was successful
if [ $TRANSFER_STATUS -eq 0 ]; then
    echo "File transfer completed successfully"
    
    # Delete source if requested
    if [ "$DELETE" = true ]; then
        echo "Removing source file/directory: $SRC"
        rm -rf "$SRC"
        if [ $? -eq 0 ]; then
            echo "Source file/directory successfully removed"
        else
            echo "Error removing source file/directory"
            exit 1
        fi
    fi
else
    echo "File transfer failed"
    exit 1
fi

exit 0
