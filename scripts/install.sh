#!/bin/bash

# Name of the main script
SCRIPT_NAME="./scripts/webpg.sh"

# Path where the script will be installed
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/webpg"

# Copy the script to the installation directory
if sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"; then
  echo "Script copied to $INSTALL_PATH"
else
  echo "Error copying the script."
  exit 1
fi

# Make the script executable
sudo chmod +x "$INSTALL_PATH"

# Detect the shell being used (bash or zsh)
if [ "$SHELL" = "/usr/bin/zsh" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ "$SHELL" = "/usr/bin/bash" ]; then
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

# Inform the user to reload the shell configuration file
echo "Please reload your shell configuration file by running 'source $SHELL_CONFIG' or restart your terminal."

echo "Installation complete. You can now use 'webpg' to run your script."
