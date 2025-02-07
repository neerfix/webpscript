#!/bin/bash

REPO_URL="https://github.com/neerfix/webpscript"
CURRENT_VERSION="0.2.0"  # Update this with the current script version
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

# Detect the shell being used (bash or zsh)
if [ "$SHELL" = "/usr/bin/zsh" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ "$SHELL" = "/usr/bin/bash" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
else
  echo "Unsupported shell. Please manually add the alias to your shell configuration file."
  exit 1
fi

# Function to display help information
show_help() {
    echo "Usage: webpg [options]"
    echo ""
    echo "Options:"
    echo "  -v, --version               Show the script version."
    echo "  -cv, --check-version        Check for the latest version on GitHub."
    echo "  -h, --help                  Show this help message and exit."
    echo "  -dof, --deleteOriginalFile  Delete the original file after converting to WebP."
    echo ""
    echo "This script converts images in the current directory to WebP format."
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

    # Update the version in the script
    sudo sed -i "s/^CURRENT_VERSION=.*/CURRENT_VERSION=\"$latest_release\"/" /usr/local/bin/webpg

    # Clean up
    printf "\n"
    printf "${GREEN}Update complete!${NO_COLOR} Please restart the script.\n"
    exit 0
}

# Function to check for the latest version on GitHub
check_for_update() {
    echo "Checking for updates..."
    latest_release=$(curl -s "https://api.github.com/repos/neerfix/webpscript/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

    if [ "$latest_release" != "$CURRENT_VERSION" ]; then
        printf "${YELLOW}New version available: $latest_release. Updating the script...${NO_COLOR}\n"
        printf "\n"
        update_script "$latest_release"
    else
        echo "You are using the latest version: $CURRENT_VERSION."
    fi
}

# Parse arguments
deleteOriginal=false
check_for_update
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --deleteOriginalFile|-dof) deleteOriginal=true ;;
        --help|-h) show_help; exit 0 ;;
        --version|-v) printf "WebP script version: ${YELLOW}${CURRENT_VERSION} \n"; exit 0 ;;
        --check-version|-cv) check_for_update; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

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

# Main loop
while true; do
    read -r -p "Do you want to continue in this directory $(pwd)? [Y/n] " choice
    case "$choice" in
        n|N) break ;;
        y|Y|*) webpGenerate ;;
    esac
done
