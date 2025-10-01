#!/bin/bash

# Tmux Configuration Setup Script
# Sets up Tmux configuration with proper error handling

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Setup Tmux configuration
setup_tmux() {
    log_info "Setting up Tmux configuration..."

    local tmux_dir="${DOTFILES_DIR}/tmux"
    local tmux_conf_source="${tmux_dir}/tmux.conf"
    local tmux_local_source="${tmux_dir}/tmux.conf.local"

    # Check if source files exist
    if [[ ! -f "$tmux_conf_source" ]]; then
        log_error "Tmux config source not found: $tmux_conf_source"
        return 1
    fi

    if [[ ! -f "$tmux_local_source" ]]; then
        log_error "Tmux local config source not found: $tmux_local_source"
        return 1
    fi

    # Create symlinks
    safe_symlink "$tmux_conf_source" "$HOME/.tmux.conf" || return 1
    safe_symlink "$tmux_local_source" "$HOME/.tmux.conf.local" || return 1

    # Install TPM (Tmux Plugin Manager) if not present
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        log_info "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir" || {
            log_warning "Failed to install TPM, plugins may not work"
        }
    else
        log_info "TPM already installed"
    fi

    log_success "Tmux configuration setup completed"
    return 0
}

# Check Tmux installation
check_tmux() {
    log_info "Checking Tmux installation..."

    # Check if tmux is installed
    if ! command_exists tmux; then
        log_error "Tmux is not installed"
        return 1
    fi

    # Check tmux version
    local tmux_version=$(tmux -V | cut -d' ' -f2)
    log_info "Tmux version: $tmux_version"

    # Check minimum version (2.1+)
    if ! tmux -V | grep -E "tmux [2-9]\.|tmux [1-9][0-9]" >/dev/null; then
        log_warning "Tmux version may be too old. Consider upgrading to 2.1+"
    fi

    return 0
}

# Check Tmux configuration
check_tmux_config() {
    log_info "Checking Tmux configuration..."

    local config_files=(
        "$HOME/.tmux.conf"
        "$HOME/.tmux.conf.local"
    )

    local missing=()

    for config in "${config_files[@]}"; do
        if [[ ! -e "$config" ]]; then
            missing+=("$(basename "$config")")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Missing configuration files: ${missing[*]}"
        return 1
    fi

    # Test configuration syntax
    if tmux -f "$HOME/.tmux.conf" list-keys >/dev/null 2>&1; then
        log_success "Tmux configuration syntax is valid"
    else
        log_warning "Tmux configuration may have syntax issues"
        return 1
    fi

    return 0
}

# Install Tmux plugins
install_tmux_plugins() {
    log_info "Installing/updating Tmux plugins..."

    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ ! -d "$tpm_dir" ]]; then
        log_warning "TPM not found, skipping plugin installation"
        return 1
    fi

    # Run TPM install script
    if "$tpm_dir/scripts/install_plugins.sh" 2>/dev/null; then
        log_success "Tmux plugins installed/updated"
        return 0
    else
        log_warning "Plugin installation may have failed"
        return 1
    fi
}

# Check for macOS specific dependencies
check_macos_deps() {
    if is_macos; then
        log_info "Checking macOS specific dependencies..."

        # Check for reattach-to-user-namespace (needed for clipboard support)
        if ! command_exists reattach-to-user-namespace; then
            log_warning "reattach-to-user-namespace not found"
            log_info "Install with: brew install reattach-to-user-namespace"
            return 1
        else
            log_success "reattach-to-user-namespace is installed"
        fi
    fi

    return 0
}

# Main execution
main() {
    log_info "Starting Tmux setup..."

    # Check dependencies
    check_dependencies tmux git || exit 1

    # Check macOS specific dependencies
    check_macos_deps || {
        log_warning "macOS dependencies missing, some features may not work"
    }

    # Check current tmux installation
    check_tmux || {
        log_warning "Tmux installation issues detected, continuing with setup..."
    }

    # Setup tmux configuration
    setup_tmux || {
        log_error "Tmux setup failed"
        exit 1
    }

    # Install plugins
    read -p "Install/update Tmux plugins? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_tmux_plugins || {
            log_warning "Plugin installation failed or incomplete"
        }
    fi

    # Final verification
    if check_tmux_config; then
        log_success "Tmux setup completed successfully"
        log_info "In Tmux, press <prefix> + I to install plugins manually if needed"
    else
        log_warning "Tmux setup completed but configuration may need attention"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi