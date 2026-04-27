# Lazy loading for slow-starting tools
# This significantly improves zsh startup time

# Lazy load NVM (Node Version Manager)
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"

    # Lazy load nvm - only initialize when needed
    nvm() {
        unset -f nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }

    # Lazy load node/npm - initialize nvm when first used
    node() {
        unset -f node
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        node "$@"
    }

    npm() {
        unset -f npm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        npm "$@"
    }
fi

# Lazy load Pyenv (Python Version Manager)
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    # Lazy load pyenv - only initialize when needed
    pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
fi

# Lazy load Conda (Anaconda/Miniconda)
if [ -f "/opt/anaconda3/bin/conda" ]; then
    export CONDA_ROOT="/opt/anaconda3"

    # Lazy load conda - only initialize when needed
    conda() {
        unset -f conda
        __conda_setup="$("$CONDA_ROOT/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
                . "$CONDA_ROOT/etc/profile.d/conda.sh"
            else
                export PATH="$CONDA_ROOT/bin:$PATH"
            fi
        fi
        unset __conda_setup
        conda "$@"
    }
fi

# Lazy load RVM (Ruby Version Manager)
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    rvm() {
        unset -f rvm
        source "$HOME/.rvm/scripts/rvm"
        rvm "$@"
    }

    ruby() {
        unset -f ruby
        source "$HOME/.rvm/scripts/rvm"
        ruby "$@"
    }

    gem() {
        unset -f gem
        source "$HOME/.rvm/scripts/rvm"
        gem "$@"
    }
fi
