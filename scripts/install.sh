#!/bin/bash

set -e

SCRIPT_SOURCE="./scripts/webpg.sh"
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/webpg"
ALIAS_LINE="alias webpg='$INSTALL_PATH'"

# Check if source script exists
if [ ! -f "$SCRIPT_SOURCE" ]; then
  echo "❌ Source script not found at $SCRIPT_SOURCE"
  exit 1
fi

# Copy the script to /usr/local/bin
echo "📦 Installing webpg script..."
sudo cp "$SCRIPT_SOURCE" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"
echo "✅ Script installed to $INSTALL_PATH"

# Detect shell config file
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
  zsh) SHELL_CONFIG="$HOME/.zshrc" ;;
  bash) SHELL_CONFIG="$HOME/.bashrc" ;;
  fish)
    echo "🐟 Fish shell detected. Please add this manually to your config.fish:"
    echo "$ALIAS_LINE"
    exit 0
    ;;
  *)
    echo "⚠️ Unsupported shell ($SHELL_NAME). Please add the alias manually:"
    echo "$ALIAS_LINE"
    exit 0
    ;;
esac

# Add alias if not already present
if grep -q "$ALIAS_LINE" "$SHELL_CONFIG"; then
  echo "✅ Alias already exists in $SHELL_CONFIG"
else
  echo "$ALIAS_LINE" >> "$SHELL_CONFIG"
  echo "🔗 Alias added to $SHELL_CONFIG"
fi

echo ""
echo "🎉 Installation complete!"
echo "➡️ Please reload your shell config with: source $SHELL_CONFIG"
echo "✅ You can now run the script with: webpg"
