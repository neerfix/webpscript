#!/bin/bash

REPO_URL="https://github.com/neerfix/webpscript"
CURRENT_VERSION="0.2.0"  # Update this with the current script version

# Function to display help information
show_help() {
    echo "Usage: webpg [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                  Show this help message and exit."
    echo "  -dof, --deleteOriginalFile  Delete the original file after converting to WebP."
    echo ""
    echo "This script converts images in the current directory to WebP format."
}

# Function to check for the latest version on GitHub
check_for_update() {
    echo "Checking for updates..."
    latest_release=$(curl -s "https://api.github.com/repos/neerfix/webpscript/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

    if [ "$latest_release" != "$CURRENT_VERSION" ]; then
        echo "New version available: $latest_release. Updating the script..."
        update_script "$latest_release"
    else
        echo "You are using the latest version: $CURRENT_VERSION."
    fi
}

# Function to update the script
update_script() {
    latest_release="$1"
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit

    # Download the latest release
    curl -L "$REPO_URL/archive/refs/tags/$latest_release.tar.gz" -o webpscript.tar.gz

    # Extract and copy the script
    tar -xzf webpscript.tar.gz
    cd "webpscript-$latest_release" || exit
    sudo cp scripts/webpg.sh /usr/local/bin/webpg

    # Make sure the script is executable
    sudo chmod +x /usr/local/bin/webpg

    echo "Update complete! Please restart the script."
    exit 0
}

# Function to generate WebP images
webpGenerate() {
    if [ -d "$(pwd)" ]; then
        for i in "$(pwd)"/*; do
            if [ -f "$i" ]; then
                extension="${i##*.}"
                filename="${i%%.*}"
                cwebp -q 100 "$i" -o "$filename.webp"
                if [ "$deleteOriginal" = true ]; then
                    rm "$i"
                fi
            fi
        done
        exit
    else
        echo "$0: $(pwd) is not a valid directory"
        exit 1
    fi
}

# Parse arguments
deleteOriginal=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --deleteOriginalFile|-dof) deleteOriginal=true ;;
        --help|-h) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check for script updates before running the main function
check_for_update

# Main loop
while true; do
    read -r -p "Do you want to continue in this directory $(pwd)? [Y/n] " choice
    case "$choice" in
        n|N) break ;;
        y|Y|*) webpGenerate ;;
    esac
done
