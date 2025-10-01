# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for configuring development environments across multiple tools:
- **Neovim**: Modern Vim-based editor with extensive plugin ecosystem
- **Zsh**: Shell with Oh My Zsh framework and Powerlevel10k theme
- **Tmux**: Terminal multiplexer for session management
- **Git**: Version control with comprehensive alias collection
- **Spacemacs**: Emacs configuration framework

## Setup and Installation

Each tool has its own setup script that creates symlinks to the appropriate locations:

```bash
# Setup individual tools
./git/setup.sh      # Links git config and aliases
./nvim/setup.sh     # Links Neovim config and installs Packer
./tmux/setup.sh     # Links tmux configuration files
./zsh/setup.sh      # Installs Oh My Zsh and links zsh config
```

### Setup Scripts Behavior
- **git/setup.sh**: Creates symlinks for `.gitconfig` and `.gitalias.txt`
- **nvim/setup.sh**:
  - Creates `~/.config` directory if needed
  - Backs up existing nvim config to `nvim.backup`
  - Installs Packer plugin manager
  - Runs `nvim +PackerSync` to install plugins
- **tmux/setup.sh**: Links tmux configuration files
- **zsh/setup.sh**:
  - Installs Oh My Zsh framework
  - Downloads Antigen plugin manager
  - Links zsh configuration files

## Neovim Architecture

The Neovim configuration uses a modular Lua-based architecture:

### Plugin Management
- **Primary**: Uses lazy.nvim plugin manager (lua/lazy_init.lua)
- **Legacy**: Packer configuration still present but commented out
- **Auto-installation**: lazy.nvim is automatically installed if not present

### Core Structure
- `init.lua`: Main entry point that loads all modules
- `lua/core/`: Core Neovim settings (options, keymaps, colors, statusline, autocmds)
- `lua/plugins/`: Individual plugin configurations

### Key Plugins Included
- **Editor**: nvim-tree, telescope, which-key, legendary, bufferline
- **Git**: gitsigns, neogit, diffview, lazygit integration, octo (GitHub)
- **LSP**: nvim-lspconfig, nvim-lsp-installer, nvim-cmp (completion)
- **AI**: ChatGPT integration, Codeium (GitHub Copilot alternative)
- **Development**: treesitter, null-ls, spectre (search/replace)

### Language Server Setup
After Neovim setup, install language servers:
```bash
sudo apt install nodejs npm
sudo npm install -g bash-language-server pyright vscode-langservers-extracted typescript typescript-language-server
```

## Zsh Configuration

### Framework Stack
- **Oh My Zsh**: Base framework
- **Antigen**: Plugin manager for additional functionality
- **Powerlevel10k**: Advanced prompt theme

### Plugin Configuration
The zsh setup includes these Antigen bundles:
- zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting
- git, web-search, copypath, copyfile, copybuffer

### Key Aliases
- `gs` = git status
- `gd` = git diff
- `vim` = nvim (if nvim is available)

## Git Configuration

### Comprehensive Alias System
The git configuration includes an extensive alias collection from GitAlias.com with:

#### Short Commands
- Single letter aliases: `a` (add), `b` (branch), `c` (commit), `d` (diff), etc.
- Two letter variants: `aa` (add --all), `ap` (add --patch), `ca` (commit --amend)

#### Workflow Aliases
- **Topic branches**: `topic-begin`, `topic-end`, `topic-sync`, `topic-move`
- **Publishing**: `publish`, `unpublish`
- **Maintenance**: `pruner`, `repacker`, `optimizer`
- **Branch management**: `hew` (delete merged branches)

#### Advanced Features
- **Log visualization**: `ll` (log-list), `lll` (log-list-long), `chart`
- **Analytics**: `summary`, `churn`, various `log-of-*` commands
- **Reset operations**: Multiple `reset-*` and `undo-*` aliases

### User Configuration
- Name: huangcan-nreal
- Email: canhuang@xreal.com
- Includes comprehensive alias file at `~/.gitalias.txt`

## Tmux Configuration

Uses a local configuration setup with:
- Main config: `tmux.conf`
- Local overrides: `tmux.conf.local`

## Development Workflow

### Working with Neovim
1. Configuration changes are made in the dotfiles repo
2. Changes are immediately available due to symlink setup
3. Plugin changes require running `:PackerSync` or lazy.nvim equivalent

### Git Workflow
The extensive git alias system supports:
- Feature branch workflows via topic-* commands
- Code review with tools like `whois`, `whatis`, `who`
- Repository maintenance with optimization commands
- Integration with GitHub via Octo plugin in Neovim

### Common Development Commands

```bash
# Start new feature
git topic-begin feature-name

# Development cycle
git aa && git cm "message"    # add all, commit with message
git topic-sync               # sync with remote

# Complete feature
git topic-end                # cleanup and delete branch

# Repository maintenance
git summary                  # show repo statistics
git optimizer               # full repo optimization (long running)
```

## File Structure Notes

- Configuration files maintain their original structure and comments
- Setup scripts are idempotent and handle existing configurations safely
- The repository uses `.gitignore` to exclude editor temp files and lazy.nvim lock files