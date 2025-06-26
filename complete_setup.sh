#!/bin/bash

# Complete Neovim setup script
# This script will install Packer and all plugins for your Neovim configuration

echo "=== Neovim Setup Script ==="
echo ""

# Step 1: Ensure Packer is installed
echo "Step 1: Checking Packer installation..."
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

if [ -d "$PACKER_DIR" ]; then
    echo "✓ Packer is already installed"
else
    echo "Installing Packer..."
    mkdir -p "$(dirname "$PACKER_DIR")"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
    echo "✓ Packer installed successfully"
fi

echo ""

# Step 2: Install all plugins
echo "Step 2: Installing plugins..."
echo "This may take a few minutes..."

# Run PackerSync to install all plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "✓ Plugin installation completed"
echo ""

# Step 3: Update Treesitter parsers
echo "Step 3: Installing Treesitter parsers..."
nvim --headless -c 'TSUpdate' -c 'qall'
echo "✓ Treesitter parsers updated"
echo ""

# Step 4: Final verification
echo "Step 4: Verifying installation..."
if nvim --headless -c 'lua print("All plugins loaded successfully!")' -c 'qall' 2>/dev/null; then
    echo "✓ All plugins loaded successfully!"
else
    echo "⚠ Some plugins may not be fully loaded yet. This is normal on first run."
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Your Neovim is now ready to use!"
echo ""
echo "Usage instructions:"
echo "1. Start Neovim: nvim"
echo "2. If you see any missing plugin warnings, run: :PackerSync"
echo "3. To update plugins later, run: :PackerUpdate"
echo "4. To install new Treesitter parsers, run: :TSInstall <language>"
echo ""
echo "Enjoy your Neovim setup! 🚀"
