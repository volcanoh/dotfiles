#!/bin/bash

# Unified Dotfiles Installation Script
# Installs and configures all dotfiles components

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/scripts/utils.sh"

# Initialize script environment
init_script

# Installation options
INSTALL_ALL=false
INSTALL_GIT=false
INSTALL_NVIM=false
INSTALL_ZSH=false
INSTALL_TMUX=false
FORCE_INSTALL=false
SKIP_DEPS=false

# Colors and formatting
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# Print banner
print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                     DOTFILES INSTALLER                      ║"
    echo "║              Modern Development Environment Setup            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Print usage information
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install and configure dotfiles for a modern development environment.

OPTIONS:
    -a, --all           Install all components (default if no specific options)
    -g, --git           Install Git configuration only
    -n, --nvim          Install Neovim configuration only
    -z, --zsh           Install Zsh configuration only
    -t, --tmux          Install Tmux configuration only
    -f, --force         Force installation (overwrite existing configs)
    -s, --skip-deps     Skip dependency checking
    -h, --help          Show this help message

EXAMPLES:
    $0                  # Install all components (interactive)
    $0 --all            # Install all components
    $0 --nvim --zsh     # Install only Neovim and Zsh
    $0 --force --all    # Force install all components

COMPONENTS:
    Git     - Git configuration with comprehensive aliases
    Neovim  - Modern Lua-based configuration with LSP support
    Zsh     - Oh My Zsh + Antigen + Powerlevel10k theme
    Tmux    - Terminal multiplexer with custom theme

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--all)
                INSTALL_ALL=true
                shift
                ;;
            -g|--git)
                INSTALL_GIT=true
                shift
                ;;
            -n|--nvim)
                INSTALL_NVIM=true
                shift
                ;;
            -z|--zsh)
                INSTALL_ZSH=true
                shift
                ;;
            -t|--tmux)
                INSTALL_TMUX=true
                shift
                ;;
            -f|--force)
                FORCE_INSTALL=true
                shift
                ;;
            -s|--skip-deps)
                SKIP_DEPS=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # If no specific component selected, default to all
    if [[ "$INSTALL_ALL" == "false" && "$INSTALL_GIT" == "false" && \
          "$INSTALL_NVIM" == "false" && "$INSTALL_ZSH" == "false" && \
          "$INSTALL_TMUX" == "false" ]]; then
        INSTALL_ALL=true
    fi
}

# Interactive component selection
interactive_selection() {
    if [[ "$INSTALL_ALL" == "true" ]]; then
        return 0
    fi

    echo -e "${YELLOW}Select components to install:${NC}"
    echo

    # Interactive prompts
    if [[ "$INSTALL_GIT" == "false" ]]; then
        read -p "Install Git configuration? (y/n): " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_GIT=true
    fi

    if [[ "$INSTALL_NVIM" == "false" ]]; then
        read -p "Install Neovim configuration? (y/n): " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_NVIM=true
    fi

    if [[ "$INSTALL_ZSH" == "false" ]]; then
        read -p "Install Zsh configuration? (y/n): " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_ZSH=true
    fi

    if [[ "$INSTALL_TMUX" == "false" ]]; then
        read -p "Install Tmux configuration? (y/n): " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_TMUX=true
    fi
}

# Check system prerequisites
check_system() {
    log_info "Checking system prerequisites..."

    # Check OS
    local os=$(get_os)
    log_info "Detected OS: $os"

    # Check required tools
    local required_tools=("git" "curl")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install missing tools and run the installer again"
        exit 1
    fi

    log_success "System prerequisites satisfied"
}

# Install components
install_components() {
    local install_count=0
    local success_count=0

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_GIT" == "true" ]]; then
        log_info "Installing Git configuration..."
        if "${SCRIPTS_DIR}/setup-git.sh"; then
            ((success_count++))
        fi
        ((install_count++))
    fi

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_NVIM" == "true" ]]; then
        log_info "Installing Neovim configuration..."
        if "${SCRIPTS_DIR}/setup-nvim.sh"; then
            ((success_count++))
        fi
        ((install_count++))
    fi

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_ZSH" == "true" ]]; then
        log_info "Installing Zsh configuration..."
        if "${SCRIPTS_DIR}/setup-zsh.sh"; then
            ((success_count++))
        fi
        ((install_count++))
    fi

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_TMUX" == "true" ]]; then
        log_info "Installing Tmux configuration..."
        if "${SCRIPTS_DIR}/setup-tmux.sh"; then
            ((success_count++))
        fi
        ((install_count++))
    fi

    # Installation summary
    echo
    log_info "Installation Summary:"
    log_info "Components processed: $install_count"
    log_info "Successful installations: $success_count"

    if [[ $success_count -eq $install_count ]]; then
        log_success "All components installed successfully!"
    elif [[ $success_count -gt 0 ]]; then
        log_warning "$((install_count - success_count)) component(s) had issues"
    else
        log_error "All installations failed"
        exit 1
    fi
}

# Post-installation tasks
post_install() {
    log_info "Running post-installation tasks..."

    # Create useful directories
    mkdir -p "$HOME/Projects" "$HOME/.local/bin"

    # Set executable permissions on scripts
    find "${SCRIPTS_DIR}" -name "*.sh" -exec chmod +x {} \;

    log_success "Post-installation tasks completed"
}

# Print next steps
print_next_steps() {
    echo
    echo -e "${GREEN}${BOLD}🎉 Installation completed!${RESET}"
    echo
    echo -e "${YELLOW}Next steps:${NC}"

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_ZSH" == "true" ]]; then
        echo "1. Restart your terminal or run: exec zsh"
        echo "2. Complete Powerlevel10k configuration: p10k configure"
    fi

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_NVIM" == "true" ]]; then
        echo "3. Open Neovim and let plugins install: nvim"
        echo "4. Install language servers: :Mason"
    fi

    if [[ "$INSTALL_ALL" == "true" ]] || [[ "$INSTALL_TMUX" == "true" ]]; then
        echo "5. Install Tmux plugins: <prefix> + I (in tmux)"
    fi

    echo "6. Customize configurations in ~/.dotfiles/"
    echo
    echo -e "${CYAN}Enjoy your new development environment! 🚀${NC}"
}

# Main execution
main() {
    # Print banner
    print_banner

    # Parse command line arguments
    parse_args "$@"

    # Check system
    check_system

    # Interactive selection if needed
    if [[ "$INSTALL_ALL" == "false" ]]; then
        interactive_selection
    fi

    # Export environment variables for child scripts
    export FORCE_INSTALL SKIP_DEPS

    # Install components
    install_components

    # Post-installation tasks
    post_install

    # Print next steps
    print_next_steps
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi