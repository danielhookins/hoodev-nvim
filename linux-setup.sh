#!/bin/bash

# Hoodev Neovim Setup Script for Linux
# This script installs all necessary dependencies for the hoodev-nvim configuration

set -e  # Exit on any error

echo "🚀 Starting Hoodev Neovim Setup for Linux..."
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    print_error "This script is designed for Ubuntu/Debian systems with apt package manager"
    exit 1
fi

# Update package list
print_status "Updating package list..."
sudo apt update

# Install basic dependencies
print_status "Installing basic dependencies..."
sudo apt install -y curl wget git unzip

# Install Neovim
print_status "Installing Neovim..."
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+')
    print_warning "Neovim is already installed (version $NVIM_VERSION)"
    # Simple version check - if major version >= 1 or (major = 0 and minor >= 8)
    MAJOR=$(echo $NVIM_VERSION | cut -d. -f1)
    MINOR=$(echo $NVIM_VERSION | cut -d. -f2)
    if [ "$MAJOR" -gt 0 ] || [ "$MAJOR" -eq 0 -a "$MINOR" -ge 8 ]; then
        print_success "Neovim version is compatible (>= 0.8)"
    else
        print_warning "Neovim version may be too old. Consider upgrading to 0.8+"
    fi
else
    # Install latest stable Neovim
    print_status "Installing latest Neovim from GitHub releases..."
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K[^"]*')
    wget -q "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz" -O /tmp/nvim-linux64.tar.gz
    sudo tar -xzf /tmp/nvim-linux64.tar.gz -C /opt/
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm /tmp/nvim-linux64.tar.gz
    print_success "Neovim ${NVIM_VERSION} installed successfully"
fi

# Install ripgrep for Telescope
print_status "Installing ripgrep..."
if command -v rg &> /dev/null; then
    print_success "ripgrep is already installed"
else
    sudo apt install -y ripgrep
    print_success "ripgrep installed successfully"
fi

# Install fd-find for better Telescope file searching
print_status "Installing fd-find..."
if command -v fdfind &> /dev/null; then
    print_success "fd-find is already installed"
else
    sudo apt install -y fd-find
    print_success "fd-find installed successfully"
fi

# Install Go
print_status "Installing Go..."
if command -v go &> /dev/null; then
    GO_VERSION=$(go version | grep -oP 'go\K[0-9]+\.[0-9]+\.[0-9]+')
    print_warning "Go is already installed (version $GO_VERSION)"
else
    print_status "Installing latest Go from official source..."
    GO_VERSION=$(curl -s https://golang.org/VERSION?m=text)
    wget -q "https://golang.org/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    
    # Add Go to PATH if not already there
    if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
    fi
    
    # Source bashrc for current session
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$(go env GOPATH)/bin
    
    print_success "Go ${GO_VERSION} installed successfully"
fi

# Install gopls (Go Language Server)
print_status "Installing gopls (Go Language Server)..."
if command -v gopls &> /dev/null; then
    print_success "gopls is already installed"
else
    go install golang.org/x/tools/gopls@latest
    print_success "gopls installed successfully"
fi

# Install a Nerd Font (FiraCode)
print_status "Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if ls "$FONT_DIR"/FiraCode* &> /dev/null; then
    print_success "FiraCode Nerd Font is already installed"
else
    print_status "Downloading FiraCode Nerd Font..."
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip" -O /tmp/FiraCode.zip
    unzip -q /tmp/FiraCode.zip -d /tmp/FiraCode/
    cp /tmp/FiraCode/*.ttf "$FONT_DIR/"
    fc-cache -fv > /dev/null 2>&1
    rm -rf /tmp/FiraCode.zip /tmp/FiraCode/
    print_success "FiraCode Nerd Font installed successfully"
fi

# Create Neovim config directory structure
print_status "Setting up Neovim configuration..."
NVIM_CONFIG_DIR="$HOME/.config/nvim"
HOODEV_DIR="$NVIM_CONFIG_DIR/lua/hoodev-nvim"

mkdir -p "$NVIM_CONFIG_DIR"

# Check if hoodev-nvim is already set up
if [ -f "$NVIM_CONFIG_DIR/init.lua" ] && grep -q "hoodev-nvim" "$NVIM_CONFIG_DIR/init.lua"; then
    print_success "Neovim configuration is already set up"
else
    # Create main init.lua if it doesn't exist or doesn't reference hoodev-nvim
    if [ ! -f "$NVIM_CONFIG_DIR/init.lua" ] || ! grep -q "hoodev-nvim" "$NVIM_CONFIG_DIR/init.lua"; then
        echo 'require("hoodev-nvim")' > "$NVIM_CONFIG_DIR/init.lua"
        print_success "Created main init.lua configuration"
    fi
fi

# Install Node.js (useful for additional LSP servers)
print_status "Installing Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js is already installed ($NODE_VERSION)"
else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    print_success "Node.js installed successfully"
fi

echo ""
echo "=============================================="
print_success "🎉 Hoodev Neovim setup completed successfully!"
echo "=============================================="
echo ""
print_status "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. Set your terminal font to 'FiraCode Nerd Font' for proper icons"
echo "3. Open Neovim with: nvim"
echo "4. Plugins will auto-install on first launch"
echo "5. Run :checkhealth to verify everything is working"
echo ""
print_status "Key bindings:"
echo "  <space>ff - Find files"
echo "  <space>fg - Live grep search"
echo "  <space>pv - File explorer"
echo "  gd        - Go to definition (in Go files)"
echo "  K         - Show hover documentation"
echo ""
print_warning "Remember to configure your terminal to use 'FiraCode Nerd Font' for proper icon display!"
