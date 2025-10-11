# Dotfiles

> A modern, secure, and modular dotfiles configuration for efficient development environments

This repository contains a comprehensive dotfiles configuration for **Neovim**, **Zsh**, **Tmux**, **Git**, and **Spacemacs**. The configuration is designed to be modular, well-documented, **privacy-focused**, and easy to maintain with **automated private configuration management**.

## ✨ Features

- **🚀 Modern Neovim** with lazy.nvim plugin manager and comprehensive LSP support
- **🔧 Enhanced Zsh** with Oh My Zsh, Antigen, and Powerlevel10k theme
- **📱 Tmux** configuration for productive terminal multiplexing
- **📝 Powerful Git** with 300+ aliases and advanced workflow enhancements
- **🎨 Spacemacs** configuration for Emacs users
- **🔒 Private Configuration System** - Keep sensitive data secure and shareable
- **⚡ Fast setup** with automated installation scripts
- **🔄 Modular design** for easy customization and maintenance
- **🛡️ Safe installation** with automatic backups and error handling
- **📋 Rich Markdown Support** with live rendering and syntax highlighting

## 🔒 Security & Privacy

This dotfiles repository includes a **comprehensive private configuration system** that keeps your sensitive information (API keys, user details, tokens) separate from version control:

- **🔐 Secure by Default:** Private data never enters git history
- **📄 Template System:** Config files use placeholders for sensitive data
- **🎯 Automated Setup:** Scripts handle private data injection automatically
- **📤 Shareable:** Repository can be safely shared publicly

### Private Information Protected:
- Git user name and email
- API tokens and keys (MODEL_PROXY_TOKEN, etc.)
- SSH configurations
- Work/personal email addresses
- Custom environment variables

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

2. **Run the installation script:**
   ```bash
   ./install.sh                 # Complete automated setup with private config handling
   ```

   Or set up individual components using centralized scripts:
   ```bash
   ./scripts/setup-git.sh       # Git with private config support
   ./scripts/setup-zsh.sh       # Zsh with private config support
   ./scripts/setup-nvim.sh      # Neovim setup
   ./scripts/setup-tmux.sh      # Tmux setup
   ```

3. **Configure private information:**

   The setup scripts will create `~/.config/private/dotfiles.conf`. Edit it with your personal information:
   ```bash
   nano ~/.config/private/dotfiles.conf
   ```

4. **Private configuration is applied automatically** during setup, but you can re-run if needed:
   ```bash
   ./scripts/setup-git.sh && ./scripts/setup-zsh.sh
   ```

## 📁 Repository Structure

```
.dotfiles/
├── git/                         # Git configuration
│   ├── gitconfig               # Git configuration file
│   └── gitalias.txt           # 300+ comprehensive git aliases
├── zsh/                         # Zsh configuration
│   ├── zshrc                   # Main zsh configuration
│   ├── p10k.zsh               # Powerlevel10k theme configuration
│   ├── aliases/               # Shell aliases (modular)
│   │   ├── main.zsh          # Core aliases
│   │   ├── git.zsh           # Git shell aliases
│   │   ├── cc.zsh            # Claude Code aliases
│   │   └── fzf.zsh           # FZF integration aliases
│   ├── functions/             # Shell functions
│   ├── exports/               # Environment variables
│   └── config/                # Additional configurations
├── nvim/                        # Neovim configuration
│   ├── init.lua               # Main configuration file
│   ├── lua/
│   │   ├── config/            # LazyVim configuration
│   │   │   ├── keymaps.lua   # Custom keybindings
│   │   │   └── lazy.lua      # Lazy.nvim setup
│   │   └── plugins/           # Plugin configurations
│   │       ├── claudecode.lua    # Claude Code integration
│   │       ├── marksman.lua      # Markdown LSP
│   │       ├── render-markdown.lua # Rich markdown rendering
│   │       ├── csvview.lua       # CSV file viewing
│   │       └── example.lua       # LazyVim example configs
├── tmux/                        # Tmux configuration
│   ├── tmux.conf              # Main tmux configuration
│   └── tmux.conf.local        # Local tmux overrides
├── scripts/                     # Installation and utility scripts
│   ├── utils.sh               # Common utility functions
│   ├── setup-git.sh           # Git setup script
│   ├── setup-nvim.sh          # Neovim setup script
│   ├── setup-zsh.sh           # Zsh setup script
│   └── setup-tmux.sh          # Tmux setup script
├── spacemacs/                   # Spacemacs configuration
│   └── init.el                # Spacemacs configuration
├── install.sh                   # Unified installation script
├── README.md                    # This file
├── CLAUDE.md                    # Claude Code guidance
└── .gitignore                   # Excludes private configs and generated files
```

## 🔧 Configuration Details

### Neovim
- **Plugin Manager:** lazy.nvim for fast startup and lazy loading
- **LSP:** Full LSP support with mason.nvim for easy language server management
- **Markdown:** Enhanced with marksman LSP and live rendering via render-markdown.nvim
- **Completion:** nvim-cmp with multiple sources
- **Git Integration:** Comprehensive git workflow with gitsigns, neogit, diffview
- **AI Integration:** Claude Code integration for AI-powered development
- **File Management:** nvim-tree, telescope for fuzzy finding
- **CSV Support:** csvview.nvim for viewing CSV files

### Zsh
- **Framework:** Oh My Zsh with Antigen for plugin management
- **Theme:** Powerlevel10k for a beautiful and informative prompt
- **Plugins:** Auto-suggestions, syntax highlighting, and more
- **Modular Design:** Separate files for aliases, functions, exports, and config
- **Private Config:** Template-based system for API tokens and sensitive data
- **Rich Aliases:** 60+ git shell aliases + comprehensive system shortcuts

### Tmux
- **Theme:** Customized theme with battery, date, and system information
- **Key Bindings:** Vim-like navigation and window management
- **Plugins:** TPM (Tmux Plugin Manager) support
- **Mouse Support:** Enabled for easy interaction

### Git
- **Comprehensive Aliases:** 300+ git aliases from gitalias.com
- **Dual System:** Git aliases (`git aa`) + shell aliases (`gaa`)
- **Workflow:** Topic branch workflows, maintenance commands, analytics
- **Private Config:** Template-based user configuration
- **Integration:** Seamless integration with Neovim and shell

## 🔒 Private Configuration System

### How It Works

1. **Templates** contain placeholders like `{{GIT_USER_NAME}}`
2. **Private config** at `~/.config/private/dotfiles.conf` contains your actual data
3. **Setup scripts** combine templates + private data → final configs
4. **Generated configs** are automatically ignored by git

### Supported Private Data

```bash
# Example ~/.config/private/dotfiles.conf
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"
MODEL_PROXY_TOKEN="your-api-token"
```

### Adding New Private Configs

1. Add variable to `config/private.conf.template`
2. Use `{{VARIABLE_NAME}}` in config templates
3. Update setup scripts to process the variable
4. Add generated config to `.gitignore`

See `PRIVATE_CONFIG.md` for detailed documentation.

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

# Regenerate configs with latest changes
./scripts/setup-git.sh && ./scripts/setup-zsh.sh

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

# Check private config status
ls -la ~/.config/private/dotfiles.conf

# Verify generated configs are ignored
git status --ignored
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

1. **Private config not found:**
   ```bash
   # Run any setup script to create template
   ./scripts/setup-git.sh
   # Edit the created config
   nano ~/.config/private/dotfiles.conf
   # Run setup again if needed
   ./scripts/setup-git.sh
   ```

2. **Zsh not loading properly:**
   ```bash
   # Check zsh installation
   which zsh
   # Regenerate config
   ./scripts/setup-zsh.sh
   # Reload configuration
   source ~/.zshrc
   ```

3. **Neovim plugins not working:**
   ```bash
   # Check Neovim version
   nvim --version
   # Reinstall plugins
   nvim +Lazy clean +Lazy sync +qa
   ```

4. **Git aliases not working:**
   ```bash
   # Regenerate git config
   ./scripts/setup-git.sh
   # Check git configuration
   git config --list | grep alias
   ```

5. **Marksman LSP not working:**
   ```bash
   # Check LSP status in nvim
   :LspInfo
   # Check mason installation
   :Mason
   ```

### Getting Help

1. Check `PRIVATE_CONFIG.md` for private configuration issues
2. Check `CLAUDE.md` for Claude Code integration guidance
3. Run setup scripts with debug mode: `DEBUG=1 ./scripts/setup-git.sh`
4. Open an issue on the repository with details about your system and the problem

## 🔐 Security Best Practices

- **Never commit** `~/.config/private/dotfiles.conf`
- **Always verify** `.gitignore` includes private files before pushing
- **Review templates** before sharing your dotfiles publicly
- **Use encryption** for additional security if needed
- **Backup private configs** separately from the main repository

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) community
- [Neovim](https://neovim.io/) developers
- [LazyVim](https://github.com/LazyVim/LazyVim) framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [GitAlias](https://gitalias.com/) project
- [Tmux](https://github.com/tmux/tmux) developers
- [Claude Code](https://claude.ai/code) integration

## 🤝 Contributing

While this is a personal dotfiles repository, suggestions and improvements are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes (ensure private config system compatibility)
4. Submit a pull request

**Note:** When contributing, please ensure any new configurations support the private config system by using templates and setup scripts.

---

**Happy coding with secure, shareable dotfiles!** 🚀🔒