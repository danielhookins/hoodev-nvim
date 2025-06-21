# Hoodev Neovim Setup

This repository contains a modular Neovim configuration designed for productivity and ease of use. It leverages Lua for configuration and uses `packer.nvim` for plugin management.

## Requirements

- **Neovim**: Version 0.7 or higher is recommended.
- **Git**: Required for plugin management.
- **A Nerd Font**: For proper icon rendering in the UI (e.g., [FiraCode Nerd Font](https://www.nerdfonts.com/)).
- **Optional**: Language servers, formatters, and linters for enhanced development experience (see `lsp.lua`).

## Installation Instructions

### 1. Install Neovim

#### Windows
- Download the latest Neovim release from [neovim.io](https://neovim.io/download/).
- Extract and add the `bin` directory to your `PATH`.

#### macOS
- Using Homebrew:
  ```sh
  brew install neovim
  ```

#### Ubuntu/Linux
- Using apt:
  ```sh
  sudo apt update
  sudo apt install neovim
  ```

### 2. Install Git

#### Windows
- Download and install from [git-scm.com](https://git-scm.com/download/win).

#### macOS
- Using Homebrew:
  ```sh
  brew install git
  ```

#### Ubuntu/Linux
- Using apt:
  ```sh
  sudo apt install git
  ```

### 3. Install a Nerd Font
- Download a font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and set it as your terminal/editor font.

### 4. Set Up the Configuration

1. **Clone or copy this configuration** into your Neovim config directory:
   - **Windows**: `C:\Users\<YourUser>\AppData\Local\nvim\`
   - **macOS/Linux**: `~/.config/nvim/`

2. Ensure the following files are present:
   - `init.lua`
   - `packer.lua`
   - `lsp.lua`
   - `remap.lua`
   - `set.lua`
   - `theme.lua`

3. **Install Plugins**
   - Open Neovim and run:
     ```vim
     :PackerSync
     ```
   - This will install all plugins defined in `packer.lua`.

### 5. (Optional) Install Language Servers
- For enhanced LSP support, install language servers as needed. See `lsp.lua` for configuration details.

#### Go Development Setup
- To use golang autocompletion and language support:
  1. Install Go according to [official instructions](https://golang.org/doc/install)
  2. Install `gopls` (Go's language server)
    `go install golang.org/x/tools/gopls@latest`
  3. The configuration includes:
     - Auto-importing of packages
     - Function parameter placeholders
     - Auto-completion via nvim-cmp
     - Static analysis via gopls
  4. Navigate with key bindings defined in `lsp.lua` (e.g., `<leader>gd` for go to definition)

## Updating Plugins
- Open Neovim and run:
  ```vim
  :PackerUpdate
  ```

## Troubleshooting
- If you encounter issues, ensure Neovim and Git are up to date.
- Check the output of `:PackerSync` for plugin installation errors.

## File Overview
- `init.lua`: Main entry point, loads all modules.
- `packer.lua`: Plugin management with packer.nvim.
- `lsp.lua`: Language Server Protocol configuration and autocompletion setup.
- `remap.lua`: Custom key mappings.
- `set.lua`: General Neovim settings.
- `theme.lua`: Colorscheme and UI customization.

## Features

### Autocompletion
The setup includes a powerful autocompletion system based on nvim-cmp with the following features:
- LSP-based completions (including gopls for Go)
- Buffer word completions
- Path completions
- Snippet support via LuaSnip
- Duplicate handling via cmp-under-comparator

The autocompletion system is configured to prioritize completions in this order:
1. LSP suggestions (from gopls for Go files)
2. Snippets
3. Buffer words
4. Path completions

Duplicates are eliminated through a combination of:
1. Custom deduplication logic that prevents duplicate LSP entries
2. The cmp-under-comparator plugin for enhanced filtering and sorting
3. Source priority system ensuring the most relevant completion appears first

**Usage**:
- Trigger completion: `<Ctrl>+<Space>`
- Navigate completions: `<Tab>` and `<Shift>+<Tab>`
- Confirm selection: `<Enter>`
