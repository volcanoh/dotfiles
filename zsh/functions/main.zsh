# Utility Functions
# This file contains useful shell functions

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives of various types
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.xz)        unxz "$1"        ;;
            *.lzma)      unlzma "$1"      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create compressed archive
compress() {
    if [ $# -eq 0 ]; then
        echo "Usage: compress <archive_name> <files_or_directories>"
        return 1
    fi

    local archive_name="$1"
    shift

    case "$archive_name" in
        *.tar.gz|*.tgz)  tar czf "$archive_name" "$@" ;;
        *.tar.bz2|*.tbz) tar cjf "$archive_name" "$@" ;;
        *.tar.xz)        tar cJf "$archive_name" "$@" ;;
        *.tar)           tar cf "$archive_name" "$@"  ;;
        *.zip)           zip -r "$archive_name" "$@"  ;;
        *.7z)            7z a "$archive_name" "$@"    ;;
        *)               echo "Unsupported archive format: $archive_name" ;;
    esac
}

# Find file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
    find . -type d -iname "*$1*"
}

# Search file contents using grep
searchfiles() {
    grep -r "$1" .
}

# Quick backup of a file
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Get the size of a directory
dirsize() {
    du -sh "${1:-$PWD}"
}

# Count files in directory
count() {
    find "${1:-$PWD}" -type f | wc -l
}

# Show PATH in readable format
showpath() {
    echo "$PATH" | tr ':' '\n' | nl
}

# Kill process by name
killname() {
    if [ -z "$1" ]; then
        echo "Usage: killname <process_name>"
        return 1
    fi
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Git functions
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Checkout git branch with fzf selection
git-checkout-branch() {
    local branches branch
    branches=$(git branch -a) &&
    branch=$(echo "$branches" | fzf +s +m -e) &&
    git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}

# Git commit with message
git-commit-msg() {
    git commit -m "$*"
}

# Git add, commit and push
git-add-commit-push() {
    git add .
    git commit -m "$*"
    git push
}

# Create and switch to new git branch
git-new-branch() {
    git checkout -b "$1"
}

# Docker functions
dsh() {
    docker exec -it "$1" /bin/bash
}

dshell() {
    docker exec -it "$1" /bin/sh
}

# Network functions
port() {
    lsof -n -i:"$1" | grep LISTEN
}

# Weather function
get-weather() {
    curl -s "wttr.in/${1:-}"
}

# Generate random password
genpass() {
    local length=${1:-16}
    openssl rand -base64 32 | cut -c1-"$length"
}

# URL encode/decode
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# JSON pretty print
jsonpp() {
    if [ -t 0 ]; then
        # Input from argument
        echo "$1" | python3 -m json.tool
    else
        # Input from pipe
        python3 -m json.tool
    fi
}

# Quick HTTP server
http-server() {
    local port=${1:-8000}
    python3 -m http.server "$port"
}

# QR code generation
qrcode() {
    echo "$1" | qrencode -t UTF8
}

# Base64 encode/decode
b64encode() {
    echo -n "$1" | base64
}

b64decode() {
    echo -n "$1" | base64 -d
}

# File checksum
checksum() {
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1"
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1"
    else
        echo "No checksum utility found"
    fi
}

# Docker cleanup
docker-cleanup() {
    docker system prune -af
    docker volume prune -f
}

# Memory usage by process
memuse() {
    ps aux | sort -rn -k 4 | head -20
}

# CPU usage by process
cpuuse() {
    ps aux | sort -rn -k 3 | head -20
}

# Disk usage with human readable sizes
diskuse() {
    df -h | grep -E '^/dev/'
}

# Find large files
findlarge() {
    local size=${1:-100M}
    find . -type f -size +"$size" -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# Quick note taking
note() {
    local note_file="$HOME/notes.txt"
    if [ $# -eq 0 ]; then
        # Display notes
        cat "$note_file" 2>/dev/null || echo "No notes found"
    else
        # Add note with timestamp
        echo "$(date): $*" >> "$note_file"
        echo "Note added: $*"
    fi
}

# SSH key management
ssh-copy() {
    if [ -z "$1" ]; then
        echo "Usage: ssh-copy <hostname>"
        return 1
    fi
    ssh-copy-id -i ~/.ssh/id_rsa.pub "$1"
}

# Load additional function files if they exist
for func_file in ~/.dotfiles/zsh/functions/*.zsh; do
    [[ -r "$func_file" && "$(basename "$func_file")" != "main.zsh" ]] && source "$func_file"
done