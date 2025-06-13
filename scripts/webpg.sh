#!/bin/bash

REPO_URL="https://github.com/neerfix/webpscript"
CURRENT_VERSION="0.2.3"  # Update this with the current script version
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

SUPPORTED_EXTENSIONS="jpg jpeg png bmp tiff"

# Detect shell config
case "$SHELL" in
  */zsh) SHELL_CONFIG="$HOME/.zshrc" ;;
  */bash) SHELL_CONFIG="$HOME/.bashrc" ;;
  *) echo "Unsupported shell. Please manually add the alias to your shell configuration file."; ;;
esac

# Display help
show_help() {
    echo "Usage: webpg [options]"
    echo ""
    echo "Options:"
    echo "  -v, --version               Show the script version."
    echo "  -cv, --check-version        Check for the latest version on GitHub."
    echo "  -h, --help                  Show this help message and exit."
    echo "  -dof, --deleteOriginalFile  Delete the original file after converting to WebP."
    echo "  -r, --recursive             Recursively convert images in subdirectories."
    echo ""
}

# Update script
update_script() {
    latest_release="$1"
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit

    curl -L "$REPO_URL/archive/refs/tags/$latest_release.tar.gz" -o webpscript.tar.gz
    tar -xzf webpscript.tar.gz 2>/dev/null

    extracted_dir=$(find . -type d -name "webpscript-$latest_release" | head -n 1)
    if [ -z "$extracted_dir" ]; then
        echo "Failed to extract script."
        exit 1
    fi

    sudo cp "$extracted_dir/scripts/webpg.sh" /usr/local/bin/webpg
    sudo chmod +x /usr/local/bin/webpg

    printf "\n${GREEN}Update complete!${NO_COLOR} Please restart the script.\n"
    exit 0
}

# Version check (macOS compatible grep)
check_for_update() {
    echo "Checking for updates..."
    latest_release=$(curl -s "https://api.github.com/repos/neerfix/webpscript/releases/latest" | sed -n 's/.*"tag_name": "\(.*\)".*/\1/p')

    if [ "$latest_release" != "$CURRENT_VERSION" ] && [ -n "$latest_release" ]; then
        printf "${YELLOW}New version available: $latest_release. Updating the script...${NO_COLOR}\n"
        update_script "$latest_release"
    else
        echo "You are using the latest version: $CURRENT_VERSION."
    fi
}

# Parse args
deleteOriginal=false
recursive=false
check_for_update
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -dof|--deleteOriginalFile) deleteOriginal=true ;;
        -r|--recursive) recursive=true ;;
        -v|--version) echo "WebP script version: $CURRENT_VERSION"; exit 0 ;;
        -cv|--check-version) check_for_update; exit 0 ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter: $1"; show_help; exit 1 ;;
    esac
    shift
done

# WebP generation
webpGenerate() {
    echo "Converting images in: $(pwd)"
    if [ "$recursive" = true ]; then
        find_opts="-type f"
    else
        find_opts="-maxdepth 1 -type f"
    fi

    found=false
    find . $find_opts | while IFS= read -r i; do
        ext="${i##*.}"
        lc_ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        if [[ " $SUPPORTED_EXTENSIONS " == *" $lc_ext "* ]]; then
            filename="${i%.*}"
            cwebp -quiet -q 100 "$i" -o "$filename.webp" && found=true

            if [ "$deleteOriginal" = true ]; then
                rm "$i"
            fi
        fi
    done

    if [ "$found" = false ]; then
        echo "No image files found to convert."
    fi
    exit 0
}

# Prompt to confirm
while true; do
    read -r -p "Do you want to continue in this directory $(pwd)? [Y/n] " choice
    case "$choice" in
        n|N) break ;;
        y|Y|"") webpGenerate ;;
    esac
done
