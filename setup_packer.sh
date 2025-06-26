#!/bin/bash

# Setup script for Packer.nvim
# This script will install Packer plugin manager for Neovim

echo "Setting up Packer.nvim..."

# Define the packer installation directory
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# Check if Packer is already installed
if [ -d "$PACKER_DIR" ]; then
    echo "Packer is already installed at $PACKER_DIR"
    echo "Updating Packer..."
    cd "$PACKER_DIR" && git pull
else
    echo "Installing Packer to $PACKER_DIR"
    # Create the directory structure if it doesn't exist
    mkdir -p "$(dirname "$PACKER_DIR")"
    
    # Clone Packer repository
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

echo "Packer installation complete!"
echo ""
echo "Next steps:"
echo "1. Start Neovim: nvim"
echo "2. Run ':PackerSync' to install all plugins"
echo "3. Restart Neovim"

# Make the script executable
chmod +x "$0"
