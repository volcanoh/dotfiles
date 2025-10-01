# Dotfiles

> A modern, modular dotfiles configuration for efficient development environments

This repository contains my personal dotfiles configuration for **Neovim**, **Zsh**, **Tmux**, **Git**, and **Spacemacs**. The configuration is designed to be modular, well-documented, and easy to maintain.

## ✨ Features

- **🚀 Modern Neovim** with lazy.nvim plugin manager and LSP support
- **🔧 Zsh** with Oh My Zsh, Antigen, and Powerlevel10k theme
- **📱 Tmux** configuration for productive terminal multiplexing
- **📝 Git** with comprehensive aliases and workflow enhancements
- **🎨 Spacemacs** configuration for Emacs users
- **⚡ Fast setup** with automated installation scripts
- **🔄 Modular design** for easy customization and maintenance
- **🛡️ Safe installation** with automatic backups and error handling

## 🚀 Quick Start

### Prerequisites

- **Git** (for cloning and version control)
- **Zsh** (recommended shell)
- **Node.js** and **npm** (for language servers)
- **Neovim** 0.8+ (for modern Lua configuration)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the unified installer:**
   ```bash
   ./install.sh
   ```

   Or install individual components:
   ```bash
   ./scripts/setup-git.sh      # Git configuration
   ./scripts/setup-nvim.sh     # Neovim setup
   ./scripts/setup-zsh.sh      # Zsh configuration
   ./scripts/setup-tmux.sh     # Tmux setup
   ```

## 📁 Repository Structure

```
.dotfiles/
├── git/                    # Git configuration
│   ├── gitconfig          # Main git configuration
│   ├── gitalias.txt       # Comprehensive git aliases
│   └── setup.sh           # Git setup script
├── nvim/                   # Neovim configuration
│   ├── init.lua           # Main configuration file
│   ├── lua/
│   │   ├── core/          # Core Neovim settings
│   │   │   ├── options.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── autocmds.lua
│   │   │   ├── colors.lua
│   │   │   └── statusline.lua
│   │   └── plugins/       # Plugin configurations (organized by category)
│   │       ├── ui/        # UI and interface plugins
│   │       ├── editor/    # Editor enhancement plugins
│   │       ├── coding/    # Coding and development plugins
│   │       ├── git/       # Git integration plugins
│   │       └── ai/        # AI and productivity plugins
│   └── setup.sh           # Neovim setup script
├── zsh/                    # Zsh configuration
│   ├── zshrc              # Main zsh configuration
│   ├── p10k.zsh           # Powerlevel10k theme configuration
│   ├── aliases/           # Shell aliases
│   │   └── main.zsh
│   ├── functions/         # Shell functions
│   │   └── main.zsh
│   ├── exports/           # Environment variables
│   │   └── main.zsh
│   ├── config/            # Additional configurations
│   │   └── main.zsh
│   └── setup.sh           # Zsh setup script
├── tmux/                   # Tmux configuration
│   ├── tmux.conf          # Main tmux configuration
│   ├── tmux.conf.local    # Local tmux overrides
│   └── setup.sh           # Tmux setup script
├── spacemacs/              # Spacemacs configuration
│   └── init.el            # Spacemacs configuration
├── scripts/                # Installation and utility scripts
│   ├── utils.sh           # Common utility functions
│   ├── setup-git.sh       # Git setup script
│   ├── setup-nvim.sh      # Neovim setup script
│   ├── setup-zsh.sh       # Zsh setup script
│   └── setup-tmux.sh      # Tmux setup script
├── config/                 # Configuration files and backups
│   └── backup/            # Automatic backups directory
├── docs/                   # Documentation
├── tools/                  # Additional tools and utilities
├── install.sh              # Unified installation script
├── README.md              # This file
└── CLAUDE.md              # Claude Code guidance
```

## 🔧 Configuration Details

### Neovim
- **Plugin Manager:** lazy.nvim for fast startup and lazy loading
- **LSP:** Full LSP support with mason.nvim for easy language server management
- **Completion:** nvim-cmp with multiple sources
- **Git Integration:** Comprehensive git workflow with gitsigns, neogit, diffview
- **AI Integration:** ChatGPT and Codeium support
- **File Management:** nvim-tree, telescope for fuzzy finding

### Zsh
- **Framework:** Oh My Zsh with Antigen for plugin management
- **Theme:** Powerlevel10k for a beautiful and informative prompt
- **Plugins:** Auto-suggestions, syntax highlighting, and more
- **Modular Design:** Separate files for aliases, functions, exports, and config

### Tmux
- **Theme:** Customized theme with battery, date, and system information
- **Key Bindings:** Vim-like navigation and window management
- **Plugins:** TPM (Tmux Plugin Manager) support
- **Mouse Support:** Enabled for easy interaction

### Git
- **Aliases:** 100+ git aliases from gitalias.com
- **Workflow:** Topic branch workflows, maintenance commands
- **Integration:** Seamless integration with Neovim and shell

## 🎨 Customization

### Adding Custom Configurations

1. **Zsh Customizations:**
   ```bash
   # Add custom aliases
   echo 'alias myalias="my command"' >> ~/.dotfiles/zsh/aliases/custom.zsh

   # Add custom functions
   echo 'myfunction() { echo "Hello $1"; }' >> ~/.dotfiles/zsh/functions/custom.zsh
   ```

2. **Neovim Plugins:**
   Create new plugin files in `~/.dotfiles/nvim/lua/plugins/` following the existing structure.

3. **Local Overrides:**
   Create `~/.zshrc.local` for zsh-specific local customizations that won't be tracked in git.

### Updating Configurations

```bash
cd ~/.dotfiles
git pull origin main

# Update plugins
nvim +Lazy sync +qa
```

## 🛠️ Maintenance

### Backup and Restore

The installation scripts automatically create backups in `~/.dotfiles/config/backup/` with timestamps.

To restore a backup:
```bash
mv ~/.dotfiles/config/backup/zshrc.backup.20231201_120000 ~/.zshrc
```

### Health Checks

Run health checks for different tools:

```bash
# Neovim health check
nvim +checkhealth +qa

# Git configuration check
git config --list

# Zsh plugin status
antibody list  # or antigen list
```

## 📋 Requirements

### System Requirements
- **macOS 10.15+** or **Linux** (Ubuntu 18.04+, CentOS 7+)
- **Git 2.20+**
- **Zsh 5.0+**
- **Neovim 0.8+**
- **Tmux 2.1+**

### Optional Dependencies
- **Node.js 16+** and **npm** (for language servers)
- **Python 3.8+** (for some plugins)
- **Ripgrep** (for faster searching)
- **FZF** (for fuzzy finding)
- **Bat** (for better syntax highlighting)
- **Exa** (for better ls replacement)

## 🚨 Troubleshooting

### Common Issues

1. **Zsh not loading properly:**
   ```bash
   # Check zsh installation
   which zsh
   # Reload configuration
   source ~/.zshrc
   ```

2. **Neovim plugins not working:**
   ```bash
   # Check Neovim version
   nvim --version
   # Reinstall plugins
   nvim +Lazy clean +Lazy sync +qa
   ```

3. **Git aliases not working:**
   ```bash
   # Check git configuration
   git config --list | grep alias
   # Reload git configuration
   git config --global include.path ~/.gitalias.txt
   ```

4. **Tmux configuration not applied:**
   ```bash
   # Reload tmux configuration
   tmux source-file ~/.tmux.conf
   ```

### Getting Help

1. Check the documentation in the `docs/` directory
2. Run the setup scripts with debug mode: `DEBUG=1 ./scripts/setup-nvim.sh`
3. Open an issue on the repository with details about your system and the problem

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) community
- [Neovim](https://neovim.io/) developers
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [GitAlias](https://gitalias.com/) project
- [Tmux](https://github.com/tmux/tmux) developers

## 🤝 Contributing

While this is a personal dotfiles repository, suggestions and improvements are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

**Happy coding!** 🚀