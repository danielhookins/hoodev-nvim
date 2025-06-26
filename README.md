# Hoodev Neovim Setup

This repository contains a modular Neovim configuration designed for productivity and ease of use. It leverages Lua for configuration and uses `packer.nvim` for plugin management.

## Requirements

- **Neovim**: Version 0.8 or higher is required for LSP and Treesitter features.
- **Git**: Required for plugin management with packer.nvim.
- **A Nerd Font**: For proper icon rendering in lualine and telescope (e.g., [FiraCode Nerd Font](https://www.nerdfonts.com/)).
- **ripgrep**: Required for telescope live_grep functionality.
- **Language servers**: For enhanced development experience (see Language Server section).

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

### 2. Install Dependencies

#### ripgrep (for Telescope search)
- **Windows**: `choco install ripgrep` or download from [GitHub releases](https://github.com/BurntSushi/ripgrep/releases)
- **macOS**: `brew install ripgrep`
- **Ubuntu/Linux**: `sudo apt install ripgrep`

#### Git
- **Windows**: Download from [git-scm.com](https://git-scm.com/download/win)
- **macOS**: `brew install git`
- **Ubuntu/Linux**: `sudo apt install git`

### 3. Install a Nerd Font
- Download a font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and set it as your terminal/editor font.

### 4. Set Up the Configuration

1. **Clone or copy this configuration** into your Neovim config directory:
   - **Windows**: `C:\Users\<YourUser>\AppData\Local\nvim\lua\hoodev-nvim\`
   - **macOS/Linux**: `~/.config/nvim/lua/hoodev-nvim/`

2. **Create the main init.lua** in your Neovim config root:
   ```lua
   -- ~/.config/nvim/init.lua (or Windows equivalent)
   require("hoodev-nvim")
   ```

3. Ensure the following files are present in the `hoodev-nvim` directory:
   - `init.lua` (module entry point)
   - `packer.lua` (plugin management)
   - `lsp.lua` (LSP and autocompletion)
   - `remap.lua` (key mappings)
   - `set.lua` (general settings)
   - `theme.lua` (colorscheme)
   - `treesitter.lua` (syntax highlighting)

4. **Install Plugins**
   - Open Neovim and run:
     ```vim
     :PackerSync
     ```
   - This will automatically install packer.nvim and all defined plugins.

## Language Server Setup

### Go Development
For Go development with full LSP support:

1. **Install Go**: Follow [official instructions](https://golang.org/doc/install)
2. **Install gopls**:
   ```bash
   go install golang.org/x/tools/gopls@latest
   ```
3. **Ensure gopls is in PATH**: Add `$GOPATH/bin` or `$GOBIN` to your PATH

The Go LSP configuration includes:
- Auto-completion via nvim-cmp
- Go to definition, references, and implementations
- Hover documentation
- Code actions and refactoring
- Automatic imports
- Static analysis and error detection
- Code formatting with gofumpt

### Adding Other Language Servers
To add support for other languages, modify `lsp.lua` and add the language server setup. Common examples:

```lua
-- TypeScript/JavaScript
nvim_lsp.tsserver.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Python
nvim_lsp.pyright.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
```

## Key Mappings

### Leader Key
- Leader key is set to `<Space>`

### File Navigation (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)

### LSP Navigation (when in Go files)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Show hover documentation
- `<space>rn` - Rename symbol
- `<space>ca` - Code actions
- `<space>f` - Format file

### General Navigation
- `<leader>pv` - Open file explorer (Ex command)
- `<leader>e` - Open diagnostic float

### Autocompletion
- `<Tab>` - Next completion item
- `<Shift-Tab>` - Previous completion item
- `<Enter>` - Accept completion
- `<Ctrl-Space>` - Trigger completion manually

## Updating Plugins
- Open Neovim and run:
  ```vim
  :PackerUpdate
  ```

## Troubleshooting

### Common Issues
1. **Plugins not installing**: Ensure Git is installed and you have internet access
2. **LSP not working**: Verify the language server is installed and in PATH
3. **Telescope not finding files**: Install ripgrep
4. **Icons not showing**: Install and configure a Nerd Font

### Checking Plugin Status
```vim
:PackerStatus    " View plugin installation status
:LspInfo         " Check LSP server status
:checkhealth     " General Neovim health check
```

## File Overview

- **`init.lua`**: Module entry point, loads all configuration modules
- **`packer.lua`**: Plugin management with packer.nvim, auto-installs if missing
- **`lsp.lua`**: LSP configuration with nvim-cmp for autocompletion
- **`remap.lua`**: Custom key mappings with leader key set to space
- **`set.lua`**: General Neovim settings and options
- **`theme.lua`**: Tokyonight colorscheme configuration
- **`treesitter.lua`**: Syntax highlighting with auto-install for Go, Lua, and Vim

## Features

### Installed Plugins
- **packer.nvim**: Plugin manager with auto-bootstrap
- **telescope.nvim**: Fuzzy finder for files and content
- **tokyonight.nvim**: Modern colorscheme
- **nvim-treesitter**: Advanced syntax highlighting
- **vim-fugitive**: Git integration
- **lualine.nvim**: Status line with icons
- **nvim-lspconfig**: LSP configuration
- **nvim-cmp**: Autocompletion engine with multiple sources
- **vim-vsnip**: Snippet support

### Autocompletion System
The setup uses nvim-cmp with the following completion sources:
1. **LSP completions** (primary source for Go via gopls)
2. **Snippets** (via vim-vsnip)
3. **File paths** (for import statements and file references)
4. **Buffer words** (fallback for any open buffers)

### Treesitter Configuration
Auto-installs and configures syntax highlighting for:
- Go and Go modules
- Lua
- Vim script and documentation
- Query language (for Treesitter queries)

The configuration enables both highlighting and indentation with Treesitter.
