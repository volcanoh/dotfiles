#!/bin/bash

# Dotfiles Utility Functions
# Provides common functions for setup scripts

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    if [[ "${DEBUG:-}" == "1" ]]; then
        echo -e "${PURPLE}[DEBUG]${NC} $1"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Check if file exists
file_exists() {
    [[ -f "$1" ]]
}

# Create backup of existing file/directory
create_backup() {
    local target="$1"
    local backup_dir="${DOTFILES_DIR}/config/backup"

    if [[ -e "$target" ]]; then
        local backup_name="$(basename "$target").backup.$(date +%Y%m%d_%H%M%S)"
        local backup_path="${backup_dir}/${backup_name}"

        log_info "Creating backup of $target -> $backup_path"
        mkdir -p "$backup_dir"

        if mv "$target" "$backup_path"; then
            log_success "Backup created: $backup_path"
            return 0
        else
            log_error "Failed to create backup of $target"
            return 1
        fi
    fi
    return 0
}

# Create symlink with backup
safe_symlink() {
    local source="$1"
    local target="$2"

    log_debug "Creating symlink: $source -> $target"

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        log_error "Source does not exist: $source"
        return 1
    fi

    # Create target directory if needed
    local target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Create backup if target exists and is not already our symlink
    if [[ -e "$target" ]] && [[ ! -L "$target" || "$(readlink "$target")" != "$source" ]]; then
        create_backup "$target" || return 1
    fi

    # Remove existing symlink if it points to wrong location
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" != "$source" ]]; then
        rm "$target"
    fi

    # Create symlink
    if ln -sf "$source" "$target"; then
        log_success "Symlink created: $target -> $source"
        return 0
    else
        log_error "Failed to create symlink: $target -> $source"
        return 1
    fi
}

# Verify installation of a tool
verify_installation() {
    local tool="$1"
    local check_command="$2"

    log_info "Verifying $tool installation..."

    if eval "$check_command" >/dev/null 2>&1; then
        log_success "$tool is properly installed"
        return 0
    else
        log_error "$tool installation verification failed"
        return 1
    fi
}

# Get OS type
get_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        CYGWIN*) echo "windows" ;;
        MINGW*)  echo "windows" ;;
        *)       echo "unknown" ;;
    esac
}

# Check if running on macOS
is_macos() {
    [[ "$(get_os)" == "macos" ]]
}

# Check if running on Linux
is_linux() {
    [[ "$(get_os)" == "linux" ]]
}

# Install package based on OS
install_package() {
    local package="$1"
    local os="$(get_os)"

    log_info "Installing package: $package"

    case "$os" in
        macos)
            if command_exists brew; then
                brew install "$package"
            else
                log_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        linux)
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y "$package"
            elif command_exists yum; then
                sudo yum install -y "$package"
            elif command_exists pacman; then
                sudo pacman -S --noconfirm "$package"
            else
                log_error "No supported package manager found"
                return 1
            fi
            ;;
        *)
            log_error "Unsupported OS: $os"
            return 1
            ;;
    esac
}

# Check and install dependencies
check_dependencies() {
    local deps=("$@")
    local missing=()

    log_info "Checking dependencies..."

    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Missing dependencies: ${missing[*]}"
        read -p "Install missing dependencies? (y/n): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for dep in "${missing[@]}"; do
                install_package "$dep" || {
                    log_error "Failed to install $dep"
                    return 1
                }
            done
        else
            log_error "Dependencies required for installation"
            return 1
        fi
    fi

    log_success "All dependencies satisfied"
    return 0
}

# Setup environment variables
setup_env() {
    export DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    export SCRIPTS_DIR="${DOTFILES_DIR}/scripts"
    export CONFIG_DIR="${DOTFILES_DIR}/config"

    log_debug "DOTFILES_DIR: $DOTFILES_DIR"
    log_debug "SCRIPTS_DIR: $SCRIPTS_DIR"
    log_debug "CONFIG_DIR: $CONFIG_DIR"
}

# Initialize script environment
init_script() {
    setup_env

    # Create necessary directories
    mkdir -p "${DOTFILES_DIR}/config/backup"
    mkdir -p "${DOTFILES_DIR}/docs"
    mkdir -p "${DOTFILES_DIR}/tools"
}