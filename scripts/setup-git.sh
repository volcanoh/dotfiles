#!/bin/bash

# Git Configuration Setup Script
# Sets up git configuration and aliases with proper error handling

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Git configuration setup
setup_git() {
    log_info "Setting up Git configuration..."

    local git_dir="${DOTFILES_DIR}/git"
    local gitconfig_source="${git_dir}/gitconfig"
    local gitalias_source="${git_dir}/gitalias.txt"

    # Check if source files exist
    if [[ ! -f "$gitconfig_source" ]]; then
        log_error "Git config source not found: $gitconfig_source"
        return 1
    fi

    if [[ ! -f "$gitalias_source" ]]; then
        log_error "Git alias source not found: $gitalias_source"
        return 1
    fi

    # Create private git configuration
    create_private_git_config || {
        log_warning "Failed to create private git config, continuing..."
    }

    # Create symlinks
    safe_symlink "$gitconfig_source" "$HOME/.gitconfig" || return 1
    safe_symlink "$gitalias_source" "$HOME/.gitalias.txt" || return 1

    # Verify git configuration
    verify_installation "Git configuration" "git config --list | grep -q user.name" || {
        log_warning "Git configuration may need manual setup for user.name and user.email"
    }

    log_success "Git configuration setup completed"
    return 0
}

# Check git configuration
check_git_config() {
    log_info "Checking current Git configuration..."

    # Check if git is installed
    if ! command_exists git; then
        log_error "Git is not installed"
        return 1
    fi

    # Check git version
    local git_version=$(git --version | cut -d' ' -f3)
    log_info "Git version: $git_version"

    # Check user configuration
    local git_user=$(git config --global --get user.name 2>/dev/null || echo "Not set")
    local git_email=$(git config --global --get user.email 2>/dev/null || echo "Not set")

    log_info "Git user.name: $git_user"
    log_info "Git user.email: $git_email"

    if [[ "$git_user" == "Not set" ]] || [[ "$git_email" == "Not set" ]]; then
        log_warning "Git user configuration incomplete"
        return 1
    fi

    return 0
}

# Main execution
main() {
    log_info "Starting Git setup..."

    # Check dependencies
    check_dependencies git || exit 1

    # Check current configuration
    check_git_config || {
        log_warning "Git configuration issues detected, continuing with setup..."
    }

    # Setup git configuration
    setup_git || {
        log_error "Git setup failed"
        exit 1
    }

    # Check private config customization
    local private_git_config="$HOME/.config/private/git.conf"
    if ! check_private_config_customization "$private_git_config" "Git"; then
        print_private_config_guidance "Git" "$private_git_config"
    fi

    # Final verification
    if check_git_config; then
        log_success "Git setup completed successfully"
    else
        log_warning "Git setup completed but configuration may need attention"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi