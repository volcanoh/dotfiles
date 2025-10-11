#!/bin/bash

# Zsh Configuration Setup Script
# Sets up Zsh with Oh My Zsh, Antigen, and Powerlevel10k theme

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Install Oh My Zsh
install_oh_my_zsh() {
    local oh_my_zsh_dir="$HOME/.oh-my-zsh"

    if [[ -d "$oh_my_zsh_dir" ]]; then
        log_info "Oh My Zsh already installed"
        return 0
    fi

    log_info "Installing Oh My Zsh..."

    # Download and run Oh My Zsh installer
    if curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        log_success "Oh My Zsh installed successfully"
        return 0
    else
        log_error "Failed to install Oh My Zsh"
        return 1
    fi
}

# Install Antigen
install_antigen() {
    local antigen_file="$HOME/.antigen.zsh"

    if [[ -f "$antigen_file" ]]; then
        log_info "Antigen already installed"
        return 0
    fi

    log_info "Installing Antigen..."

    if curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > "$antigen_file"; then
        log_success "Antigen installed successfully"
        return 0
    else
        log_error "Failed to install Antigen"
        return 1
    fi
}

# Setup Zsh configuration
setup_zsh() {
    log_info "Setting up Zsh configuration..."

    local zsh_dir="${DOTFILES_DIR}/zsh"
    local zshrc_source="${zsh_dir}/zshrc"
    local p10k_source="${zsh_dir}/p10k.zsh"

    # Check if source files exist
    if [[ ! -f "$zshrc_source" ]]; then
        log_error "Zsh config source not found: $zshrc_source"
        return 1
    fi

    if [[ ! -f "$p10k_source" ]]; then
        log_error "P10k config source not found: $p10k_source"
        return 1
    fi

    # Install Oh My Zsh
    install_oh_my_zsh || return 1

    # Install Antigen
    install_antigen || return 1

    # Create private dotfiles configuration
    create_private_dotfiles_config || {
        log_warning "Failed to create private dotfiles config, continuing..."
    }

    # Create symlinks
    safe_symlink "$zshrc_source" "$HOME/.zshrc" || return 1
    safe_symlink "$p10k_source" "$HOME/.p10k.zsh" || return 1

    log_success "Zsh configuration setup completed"
    return 0
}

# Check Zsh installation
check_zsh() {
    log_info "Checking Zsh installation..."

    # Check if zsh is installed
    if ! command_exists zsh; then
        log_error "Zsh is not installed"
        return 1
    fi

    # Check zsh version
    local zsh_version=$(zsh --version | cut -d' ' -f2)
    log_info "Zsh version: $zsh_version"

    # Check if zsh is the default shell
    if [[ "$SHELL" == */zsh ]]; then
        log_success "Zsh is the default shell"
    else
        log_warning "Zsh is not the default shell (current: $SHELL)"
    fi

    return 0
}

# Set Zsh as default shell
set_default_shell() {
    if [[ "$SHELL" == */zsh ]]; then
        log_info "Zsh is already the default shell"
        return 0
    fi

    log_info "Setting Zsh as default shell..."

    local zsh_path=$(which zsh)

    # Add zsh to /etc/shells if not present
    if ! grep -q "$zsh_path" /etc/shells 2>/dev/null; then
        log_info "Adding Zsh to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    # Change default shell
    if chsh -s "$zsh_path"; then
        log_success "Default shell changed to Zsh"
        log_info "Please restart your terminal or run 'exec zsh' to use the new shell"
        return 0
    else
        log_error "Failed to change default shell"
        return 1
    fi
}

# Check Zsh configuration
check_zsh_config() {
    log_info "Checking Zsh configuration..."

    local config_files=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.oh-my-zsh"
        "$HOME/.antigen.zsh"
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

    log_success "All Zsh configuration files are present"
    return 0
}

# Main execution
main() {
    log_info "Starting Zsh setup..."

    # Check dependencies
    check_dependencies zsh curl || exit 1

    # Check current zsh installation
    check_zsh || {
        log_warning "Zsh installation issues detected, continuing with setup..."
    }

    # Setup zsh configuration
    setup_zsh || {
        log_error "Zsh setup failed"
        exit 1
    }

    # Check if user wants to set zsh as default
    if [[ "$SHELL" != */zsh ]]; then
        read -p "Set Zsh as default shell? (y/n): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            set_default_shell || {
                log_warning "Failed to set Zsh as default shell"
            }
        fi
    fi

    # Check private config customization
    local private_config="$HOME/.config/private/dotfiles.conf"
    if ! check_private_config_customization "$private_config" "Zsh/Dotfiles"; then
        print_private_config_guidance "Zsh/Dotfiles" "$private_config"
    fi

    # Final verification
    if check_zsh_config; then
        log_success "Zsh setup completed successfully"
        log_info "Restart your terminal or run 'exec zsh' to apply changes"
    else
        log_warning "Zsh setup completed but configuration may need attention"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi