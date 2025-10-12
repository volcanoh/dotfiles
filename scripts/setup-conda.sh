#!/bin/bash

# Conda Configuration Setup Script
# Sets up conda configuration and manages conda environments

set -euo pipefail

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Initialize script environment
init_script

# Install conda for different operating systems
install_conda() {
    local os=$(get_os)
    local arch=$(uname -m)

    log_info "Installing Conda for $os ($arch)..."

    case "$os" in
        "linux")
            install_conda_linux "$arch"
            ;;
        "macos")
            install_conda_macos "$arch"
            ;;
        "windows")
            install_conda_windows
            ;;
        *)
            log_error "Unsupported operating system: $os"
            log_info "Please manually install Miniconda from: https://docs.conda.io/en/latest/miniconda.html"
            return 1
            ;;
    esac
}

# Install conda on Linux
install_conda_linux() {
    local arch="$1"
    local miniconda_url=""
    local installer_file="$HOME/miniconda_installer.sh"

    # Determine architecture and download URL
    case "$arch" in
        "x86_64")
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
            ;;
        "aarch64"|"arm64")
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
            ;;
        *)
            log_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    log_info "Downloading Miniconda installer..."
    if ! curl -fsSL "$miniconda_url" -o "$installer_file"; then
        log_error "Failed to download Miniconda installer"
        return 1
    fi

    log_info "Installing Miniconda..."
    # Install in batch mode to default location
    if bash "$installer_file" -b -p "$HOME/miniconda3"; then
        log_success "Miniconda installed successfully"

        # Clean up installer
        rm -f "$installer_file"

        # Add conda to PATH for current session
        export PATH="$HOME/miniconda3/bin:$PATH"

        return 0
    else
        log_error "Miniconda installation failed"
        rm -f "$installer_file"
        return 1
    fi
}

# Install conda on macOS
install_conda_macos() {
    local arch="$1"

    # Try Homebrew first if available
    if command_exists brew; then
        log_info "Installing Miniconda via Homebrew..."
        if brew install --cask miniconda; then
            log_success "Miniconda installed via Homebrew"

            # Add conda to PATH for current session
            if [[ -d "/usr/local/Caskroom/miniconda/base/bin" ]]; then
                export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
            elif [[ -d "/opt/homebrew/Caskroom/miniconda/base/bin" ]]; then
                export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
            fi

            return 0
        else
            log_warning "Homebrew installation failed, trying direct download..."
        fi
    fi

    # Fallback to direct download
    local miniconda_url=""
    local installer_file="$HOME/miniconda_installer.sh"

    # Determine architecture and download URL
    case "$arch" in
        "x86_64")
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
            ;;
        "arm64")
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
            ;;
        *)
            log_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    log_info "Downloading Miniconda installer..."
    if ! curl -fsSL "$miniconda_url" -o "$installer_file"; then
        log_error "Failed to download Miniconda installer"
        return 1
    fi

    log_info "Installing Miniconda..."
    if bash "$installer_file" -b -p "$HOME/miniconda3"; then
        log_success "Miniconda installed successfully"

        # Clean up installer
        rm -f "$installer_file"

        # Add conda to PATH for current session
        export PATH="$HOME/miniconda3/bin:$PATH"

        return 0
    else
        log_error "Miniconda installation failed"
        rm -f "$installer_file"
        return 1
    fi
}

# Install conda on Windows (provide instructions)
install_conda_windows() {
    log_info "Windows detected. Please install Miniconda manually:"
    echo ""
    echo "1. Download Miniconda installer from:"
    echo "   https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
    echo ""
    echo "2. Run the installer and follow the installation wizard"
    echo ""
    echo "3. After installation, restart your terminal or Git Bash"
    echo ""
    echo "4. Run this script again to configure conda"
    echo ""

    read -p "Press Enter after installing Miniconda to continue..." -r
    echo

    # Check if conda is now available
    if command_exists conda; then
        log_success "Conda installation detected"
        return 0
    else
        log_error "Conda still not found. Please ensure it's installed and in your PATH"
        return 1
    fi
}

# Check conda installation
check_conda() {
    log_info "Checking Conda installation..."

    # Check if conda is installed
    if ! command_exists conda; then
        log_warning "Conda is not installed"
        return 1
    fi

    # Check conda version
    local conda_version=$(conda --version 2>/dev/null | cut -d' ' -f2)
    log_info "Conda version: $conda_version"

    # Check conda info
    local conda_base=$(conda info --base 2>/dev/null || echo "Unknown")
    log_info "Conda base environment: $conda_base"

    return 0
}

# Setup conda configuration
setup_conda() {
    log_info "Setting up Conda configuration..."

    local conda_dir="${DOTFILES_DIR}/conda"
    local condarc_source="${conda_dir}/condarc"

    # Check if source file exists
    if [[ ! -f "$condarc_source" ]]; then
        log_error "Conda config source not found: $condarc_source"
        return 1
    fi

    # Backup existing .condarc if it exists
    if [[ -f "$HOME/.condarc" ]] && [[ ! -L "$HOME/.condarc" ]]; then
        local backup_file="$HOME/.condarc.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up existing .condarc to $backup_file"
        cp "$HOME/.condarc" "$backup_file"
    fi

    # Create symlink
    safe_symlink "$condarc_source" "$HOME/.condarc" || return 1

    # Initialize conda for shell if not already done
    initialize_conda_shell || {
        log_warning "Failed to initialize conda for shell, continuing..."
    }

    # Create private conda configuration
    create_private_conda_config || {
        log_warning "Failed to create private conda config, continuing..."
    }

    log_success "Conda configuration setup completed"
    return 0
}

# Initialize conda for shell
initialize_conda_shell() {
    log_info "Initializing conda for both bash and zsh..."

    local shells_to_init=()
    local successful_inits=0
    local total_attempts=0

    # Check which shells need initialization
    if [[ -f "$HOME/.bashrc" ]] || [[ ! -e "$HOME/.bashrc" ]]; then
        if ! grep -q "conda initialize" "$HOME/.bashrc" 2>/dev/null; then
            shells_to_init+=("bash")
        else
            log_info "Conda already initialized for bash"
        fi
    fi

    if [[ -f "$HOME/.zshrc" ]] || [[ ! -e "$HOME/.zshrc" ]]; then
        if ! grep -q "conda initialize" "$HOME/.zshrc" 2>/dev/null; then
            shells_to_init+=("zsh")
        else
            log_info "Conda already initialized for zsh"
        fi
    fi

    # If no shells need initialization
    if [[ ${#shells_to_init[@]} -eq 0 ]]; then
        log_info "Conda already initialized for all available shells"
        return 0
    fi

    # Initialize conda for each shell that needs it
    for shell in "${shells_to_init[@]}"; do
        ((total_attempts++))
        log_info "Initializing conda for $shell..."

        if conda init "$shell" >/dev/null 2>&1; then
            log_success "Conda initialized for $shell"
            ((successful_inits++))
        else
            log_warning "Failed to initialize conda for $shell"
        fi
    done

    # Report results
    if [[ $successful_inits -eq $total_attempts ]]; then
        log_success "Conda initialized for all shells (${successful_inits}/${total_attempts})"
        log_info "Please restart your shell or run one of:"
        for shell in "${shells_to_init[@]}"; do
            log_info "  source ~/.$shell"
        done
        return 0
    elif [[ $successful_inits -gt 0 ]]; then
        log_warning "Conda initialized for some shells (${successful_inits}/${total_attempts})"
        return 0
    else
        log_error "Failed to initialize conda for any shell"
        return 1
    fi
}

# Create private conda configuration
create_private_conda_config() {
    local private_dir="$HOME/.config/private"
    local private_conda_config="$private_dir/conda.conf"

    # Create private directory if it doesn't exist
    mkdir -p "$private_dir"

    # Create private conda config if it doesn't exist
    if [[ ! -f "$private_conda_config" ]]; then
        log_info "Creating private conda configuration..."

        cat > "$private_conda_config" << 'EOF'
# Private Conda Configuration
# This file is not tracked by git and contains user-specific conda settings

# Additional conda channels (uncomment and modify as needed)
# CONDA_EXTRA_CHANNELS="pytorch nvidia"

# Custom conda environments location (uncomment and modify as needed)
# export CONDA_ENVS_PATH="$HOME/conda-envs"

# Default packages for new environments (space-separated)
# CONDA_DEFAULT_PACKAGES="jupyter numpy pandas matplotlib"

# API tokens for private channels (uncomment and add tokens as needed)
# export CONDA_TOKEN_MYCOMPANY="your-token-here"

# Conda solver preference (libmamba is faster, classic is more compatible)
# export CONDA_SOLVER="libmamba"

# Auto-activate base environment (true/false)
# export CONDA_AUTO_ACTIVATE_BASE="false"

# Example: Source this file in your shell RC file
# echo "source ~/.config/private/conda.conf" >> ~/.bashrc
# echo "source ~/.config/private/conda.conf" >> ~/.zshrc
EOF

        log_success "Private conda configuration created at $private_conda_config"
        return 0
    else
        log_info "Private conda configuration already exists"
        return 0
    fi
}

# Check conda configuration
check_conda_config() {
    log_info "Checking Conda configuration..."

    local config_files=(
        "$HOME/.condarc"
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

    # Test conda configuration
    if conda config --show channels >/dev/null 2>&1; then
        log_success "Conda configuration is valid"
        return 0
    else
        log_error "Conda configuration has issues"
        return 1
    fi
}

# Install useful conda packages
install_conda_packages() {
    log_info "Installing useful conda packages..."

    # Base packages that are commonly needed
    local base_packages=(
        "conda-forge::mamba"      # Faster conda replacement
        "conda-forge::pip"        # Python package installer
        "conda-forge::jupyter"    # Jupyter notebooks
    )

    # Check if mamba is already installed
    if command_exists mamba; then
        log_info "Mamba already installed"
    else
        log_info "Installing mamba for faster package management..."
        if conda install -y "${base_packages[0]}" >/dev/null 2>&1; then
            log_success "Mamba installed successfully"
        else
            log_warning "Failed to install mamba, continuing with conda"
        fi
    fi

    # Ask user if they want to install additional packages
    read -p "Install additional useful packages (jupyter, etc.)? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local installer="conda"
        if command_exists mamba; then
            installer="mamba"
        fi

        log_info "Installing additional packages with $installer..."
        for package in "${base_packages[@]:1}"; do
            log_info "Installing $package..."
            if $installer install -y "$package" >/dev/null 2>&1; then
                log_success "Installed $package"
            else
                log_warning "Failed to install $package"
            fi
        done
    fi
}

# Main execution
main() {
    log_info "Starting Conda setup..."

    # Check dependencies first
    check_dependencies curl || exit 1

    # Check if conda is installed
    if ! check_conda; then
        log_info "Conda not found. Attempting to install..."

        # Ask user if they want to install conda
        read -p "Install Miniconda? (y/n): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_conda || {
                log_error "Conda installation failed"
                exit 1
            }

            # Verify installation
            if ! check_conda; then
                log_error "Conda installation verification failed"
                exit 1
            fi
        else
            log_error "Conda is required for this setup. Please install manually or re-run with installation."
            exit 1
        fi
    fi

    # Setup conda configuration
    setup_conda || {
        log_error "Conda setup failed"
        exit 1
    }

    # Check private config customization
    local private_conda_config="$HOME/.config/private/conda.conf"
    if ! check_private_config_customization "$private_conda_config" "Conda"; then
        print_private_config_guidance "Conda" "$private_conda_config"
    fi

    # Install useful packages (optional)
    install_conda_packages || {
        log_warning "Some conda packages failed to install"
    }

    # Final verification
    if check_conda_config; then
        log_success "Conda setup completed successfully"
        log_info "Conda has been initialized for both bash and zsh"
        log_info "Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
        log_info "To activate conda, run: conda activate"
    else
        log_warning "Conda setup completed but configuration may need attention"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi