#!/usr/bin/env bash
set -e

REPO_URL=""
INSTALL_DIR="/usr/bin"
INSTALL_PATH="$INSTALL_DIR/langtool"

echo "Downloading langtool_cli..."
curl -fsSL "$REPO_URL" -o "$INSTALL_PATH"

chmod +x "$INSTALL_PATH"

echo "Installed langtool_cli to: $INSTALL_PATH"

