#!/bin/bash

# Neovim Configuration Setup Script
# Sets up Neovim configuration with lazy.nvim plugin manager

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Install Neovim AppImage on Linux
install_neovim_appimage() {
    log_info "Installing Neovim AppImage..."

    # Check if we're on Linux
    if [[ "$(uname)" != "Linux" ]]; then
        log_warning "AppImage installation is only for Linux. Skipping..."
        return 0
    fi

    # Check if nvim is already installed and working
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n1 | cut -d' ' -f2)
        log_info "Neovim is already installed: $nvim_version"
        read -p "Reinstall Neovim AppImage? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Keeping existing Neovim installation"
            return 0
        fi
    fi

    local appimage_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"
    local install_dir="/usr/local/bin"
    local appimage_path="$install_dir/nvim.appimage"
    local nvim_symlink="$install_dir/nvim"

    # Create temporary directory for download
    local temp_dir=$(mktemp -d)
    local temp_appimage="$temp_dir/nvim-linux-x86_64.appimage"

    # Download AppImage
    log_info "Downloading Neovim AppImage from GitHub releases..."
    if ! curl -L -o "$temp_appimage" "$appimage_url"; then
        log_error "Failed to download Neovim AppImage"
        rm -rf "$temp_dir"
        return 1
    fi

    # Make AppImage executable
    chmod +x "$temp_appimage"

    # Test the AppImage works
    log_info "Testing AppImage..."
    if ! "$temp_appimage" --version >/dev/null 2>&1; then
        log_error "Downloaded AppImage is not working"
        rm -rf "$temp_dir"
        return 1
    fi

    # Install to system location (requires sudo)
    log_info "Installing AppImage to $install_dir (may require sudo)..."

    # Remove existing installations
    if [[ -f "$appimage_path" ]]; then
        sudo rm -f "$appimage_path"
    fi
    if [[ -L "$nvim_symlink" ]]; then
        sudo rm -f "$nvim_symlink"
    fi

    # Move AppImage to final location
    if ! sudo mv "$temp_appimage" "$appimage_path"; then
        log_error "Failed to install AppImage to $install_dir"
        rm -rf "$temp_dir"
        return 1
    fi

    # Create symlink for easy access
    if ! sudo ln -s "$appimage_path" "$nvim_symlink"; then
        log_error "Failed to create nvim symlink"
        rm -rf "$temp_dir"
        return 1
    fi

    # Cleanup
    rm -rf "$temp_dir"

    # Verify installation
    local installed_version=$(nvim --version | head -n1 | cut -d' ' -f2)
    log_success "Neovim AppImage installed successfully: $installed_version"
    log_info "Neovim is available at: $nvim_symlink"

    return 0
}

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

# Install ripgrep
install_ripgrep() {
    log_info "Installing ripgrep..."

    # Check if ripgrep is already installed
    if command_exists rg; then
        local rg_version=$(rg --version | head -n1 | cut -d' ' -f2)
        log_info "ripgrep is already installed: $rg_version"
        return 0
    fi

    # Install based on platform
    case "$(uname)" in
        "Linux")
            # Try to detect package manager and install
            if command_exists apt-get; then
                log_info "Installing ripgrep via apt..."
                if sudo apt-get update && sudo apt-get install -y ripgrep; then
                    log_success "ripgrep installed via apt"
                    return 0
                else
                    log_warning "apt installation failed, trying alternative method..."
                fi
            elif command_exists yum; then
                log_info "Installing ripgrep via yum..."
                if sudo yum install -y ripgrep; then
                    log_success "ripgrep installed via yum"
                    return 0
                else
                    log_warning "yum installation failed, trying alternative method..."
                fi
            elif command_exists dnf; then
                log_info "Installing ripgrep via dnf..."
                if sudo dnf install -y ripgrep; then
                    log_success "ripgrep installed via dnf"
                    return 0
                else
                    log_warning "dnf installation failed, trying alternative method..."
                fi
            fi

            # Fallback: Download binary release for Linux
            log_info "Installing ripgrep from GitHub releases..."
            local temp_dir=$(mktemp -d)
            local rg_version="14.1.0"
            local rg_url="https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/ripgrep-${rg_version}-x86_64-unknown-linux-musl.tar.gz"

            if curl -L -o "$temp_dir/ripgrep.tar.gz" "$rg_url"; then
                cd "$temp_dir"
                tar xzf ripgrep.tar.gz
                sudo cp "ripgrep-${rg_version}-x86_64-unknown-linux-musl/rg" /usr/local/bin/
                sudo chmod +x /usr/local/bin/rg
                rm -rf "$temp_dir"
                log_success "ripgrep installed from GitHub releases"
                return 0
            else
                log_error "Failed to download ripgrep"
                rm -rf "$temp_dir"
                return 1
            fi
            ;;
        "Darwin")
            if command_exists brew; then
                log_info "Installing ripgrep via Homebrew..."
                if brew install ripgrep; then
                    log_success "ripgrep installed via Homebrew"
                    return 0
                else
                    log_error "Homebrew installation failed"
                    return 1
                fi
            else
                log_error "Homebrew not found. Please install Homebrew first or install ripgrep manually"
                return 1
            fi
            ;;
        *)
            log_error "Unsupported platform for automatic ripgrep installation"
            log_info "Please install ripgrep manually from: https://github.com/BurntSushi/ripgrep"
            return 1
            ;;
    esac
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
    if ! nvim --version | head -n1 | grep -E "v0\.([8-9]|[1-9][0-9]+)\.|v[1-9]\." >/dev/null; then
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

    # Install Neovim AppImage on Linux
    install_neovim_appimage || {
        log_warning "Neovim AppImage installation failed, continuing with configuration setup..."
    }

    # Install ripgrep (required for telescope and other plugins)
    install_ripgrep || {
        log_warning "ripgrep installation failed, some Neovim plugins may not work optimally"
    }

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

    # Language servers are not automatically installed
    # Users can install them manually if needed

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