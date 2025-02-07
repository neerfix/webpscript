#!/bin/bash

# Name of the main script
SCRIPT_NAME="./scripts/webpg.sh"

# Path where the script will be installed
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/webpg"

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (using sudo)."
  exit 1
fi

# Copy the script to the installation directory
if cp "$SCRIPT_NAME" "$INSTALL_PATH"; then
  echo "Script copied to $INSTALL_PATH"
else
  echo "Error copying the script."
  exit 1
fi

# Make the script executable
chmod +x "$INSTALL_PATH"

# Detect the shell being used (bash or zsh)
if [ -n "$ZSH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
else
  echo "Unsupported shell. Please manually add the alias to your shell configuration file."
  exit 1
fi

# Add the alias to the shell configuration file
if ! grep -q "alias webpg=" "$SHELL_CONFIG"; then
  echo "alias webpg='$INSTALL_PATH'" >> "$SHELL_CONFIG"
  echo "Alias 'webpg' added to $SHELL_CONFIG"
else
  echo "Alias 'webpg' already exists in $SHELL_CONFIG"
fi

# Reload the shell configuration file
source "$SHELL_CONFIG"

echo "Installation complete. You can now use 'webpg' to run your script."
