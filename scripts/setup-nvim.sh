#!/bin/bash

# Neovim Configuration Setup Script
# Sets up Neovim configuration with lazy.nvim plugin manager

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Neovim configuration setup
setup_neovim() {
    log_info "Setting up Neovim configuration..."

    local nvim_dir="${DOTFILES_DIR}/nvim"
    local nvim_config_dir="$HOME/.config/nvim"
    local lazy_path="$HOME/.local/share/nvim/lazy/lazy.nvim"

    # Check if source directory exists
    if [[ ! -d "$nvim_dir" ]]; then
        log_error "Neovim config source not found: $nvim_dir"
        return 1
    fi

    # Create config directory
    mkdir -p "$HOME/.config"

    # Create symlink to configuration
    safe_symlink "$nvim_dir" "$nvim_config_dir" || return 1

    # Install lazy.nvim if not present
    if [[ ! -d "$lazy_path" ]]; then
        log_info "Installing lazy.nvim plugin manager..."
        git clone --filter=blob:none --branch=stable \
            https://github.com/folke/lazy.nvim.git "$lazy_path" || {
            log_error "Failed to clone lazy.nvim"
            return 1
        }
        log_success "lazy.nvim installed"
    else
        log_info "lazy.nvim already installed"
    fi

    # Install/update plugins
    log_info "Installing/updating Neovim plugins..."
    if nvim --headless "+Lazy! sync" +qa 2>/dev/null; then
        log_success "Neovim plugins synchronized"
    else
        log_warning "Plugin synchronization may have failed, check manually"
    fi

    log_success "Neovim configuration setup completed"
    return 0
}

# Check language servers
check_language_servers() {
    log_info "Checking language server installations..."

    local servers=(
        "bash-language-server:bash-language-server --version"
        "pyright:pyright --version"
        "typescript-language-server:typescript-language-server --version"
        "vscode-html-language-server:vscode-html-language-server --version"
        "vscode-css-language-server:vscode-css-language-server --version"
        "vscode-json-language-server:vscode-json-language-server --version"
    )

    local missing=()

    for server_info in "${servers[@]}"; do
        local server_name="${server_info%%:*}"
        local check_cmd="${server_info#*:}"

        if ! eval "$check_cmd" >/dev/null 2>&1; then
            missing+=("$server_name")
        else
            log_success "$server_name is installed"
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Missing language servers: ${missing[*]}"
        log_info "Install with: npm install -g ${missing[*]}"
        return 1
    fi

    return 0
}

# Install language servers
install_language_servers() {
    log_info "Installing language servers..."

    # Check if npm is available
    if ! command_exists npm; then
        log_error "npm not found. Please install Node.js and npm first"
        return 1
    fi

    local servers=(
        "bash-language-server"
        "pyright"
        "typescript-language-server"
        "typescript"
        "vscode-langservers-extracted"
    )

    log_info "Installing language servers: ${servers[*]}"

    if npm install -g "${servers[@]}"; then
        log_success "Language servers installed"
        return 0
    else
        log_error "Failed to install language servers"
        return 1
    fi
}

# Check Neovim configuration
check_neovim() {
    log_info "Checking Neovim installation..."

    # Check if neovim is installed
    if ! command_exists nvim; then
        log_error "Neovim is not installed"
        return 1
    fi

    # Check neovim version
    local nvim_version=$(nvim --version | head -n1 | cut -d' ' -f2)
    log_info "Neovim version: $nvim_version"

    # Check minimum version (0.8.0+)
    if ! nvim --version | head -n1 | grep -E "v0\.[8-9]\.|v[1-9]\." >/dev/null; then
        log_warning "Neovim version may be too old. Consider upgrading to 0.8.0+"
    fi

    # Check if configuration is properly linked
    local nvim_config="$HOME/.config/nvim"
    if [[ -L "$nvim_config" ]] && [[ -d "$nvim_config" ]]; then
        log_success "Neovim configuration is properly linked"
        return 0
    else
        log_warning "Neovim configuration not found or not linked"
        return 1
    fi
}

# Main execution
main() {
    log_info "Starting Neovim setup..."

    # Check dependencies
    check_dependencies nvim git || exit 1

    # Check current neovim installation
    check_neovim || {
        log_warning "Neovim installation issues detected, continuing with setup..."
    }

    # Setup neovim configuration
    setup_neovim || {
        log_error "Neovim setup failed"
        exit 1
    }

    # Check language servers
    if ! check_language_servers; then
        read -p "Install missing language servers? (y/n): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_language_servers || {
                log_warning "Language server installation failed"
            }
        fi
    fi

    # Final verification
    if check_neovim; then
        log_success "Neovim setup completed successfully"
    else
        log_warning "Neovim setup completed but may need attention"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi