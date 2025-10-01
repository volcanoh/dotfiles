# Environment Variables and Exports
# This file contains environment variable exports

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Editor preferences
export EDITOR='nvim'
export VISUAL='nvim'

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS="yyyy-mm-dd"

# Less settings
export LESS='-R -i -M -S -x4'
export LESSHISTFILE='-'

# Ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# FZF settings
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'

# GPG TTY (for signing commits)
export GPG_TTY=$(tty)

# Node.js settings
export NODE_OPTIONS="--max-old-space-size=4096"

# Python settings
export PYTHONDONTWRITEBYTECODE=1

# Go settings (if Go is installed)
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Rust settings (if Rust is installed)
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Homebrew settings (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Intel Macs
    if [ -d "/usr/local/Homebrew" ]; then
        export PATH="/usr/local/bin:$PATH"
    fi

    # Apple Silicon Macs
    if [ -d "/opt/homebrew" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Application-specific settings
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Colorize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Zsh settings
export ZSH_DISABLE_COMPFIX=true