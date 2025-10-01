# FZF Aliases and Functions
# Custom fzf shortcuts that don't conflict with existing key bindings

# File operations
alias ff='fzf --preview "$FZF_PREVIEW_COMMAND"'                    # Basic file finder with preview
alias fe='vim $(fzf --preview "$FZF_PREVIEW_COMMAND")'            # Find and edit file
alias fo='open $(fzf --preview "$FZF_PREVIEW_COMMAND")'           # Find and open file (macOS)

# Directory operations
alias fd='cd $(find . -type d | fzf --preview "ls -la {}")'       # Find and change directory
alias fcd='cd $(find . -type d | fzf --preview "ls -la {}")'      # Alternative name

# Git operations
alias gco='git checkout $(git branch -a | fzf | sed "s/remotes\/origin\///" | sed "s/^\* //" | xargs)'  # Git checkout branch
alias gf='git log --oneline | fzf --preview "git show {1}" | cut -d" " -f1 | xargs git show'           # Git log browser
alias ga='git add $(git status -s | fzf -m --preview "git diff {2}" | awk "{print \$2}")'              # Interactive git add

# Process management
alias fkill='ps aux | fzf | awk "{print \$2}" | xargs kill'       # Interactive process killer

# Command history (alternative to Ctrl-R)
alias fh='eval $(history | fzf --tac | sed "s/^[ ]*[0-9]*[ ]*//")'  # Find and execute from history

# Search in files (requires ripgrep)
if command -v rg >/dev/null 2>&1; then
    alias fif='rg --files-with-matches --no-messages . | fzf --preview "rg --ignore-case --pretty --context 10 . {} || cat {}"'
fi

# SSH connections (if ~/.ssh/config exists)
if [[ -f ~/.ssh/config ]]; then
    alias fssh='ssh $(grep "^Host " ~/.ssh/config | awk "{print \$2}" | fzf)'
fi

# Functions for more complex operations

# Find file and copy path to clipboard
fcp() {
    local file
    file=$(fzf --preview "$FZF_PREVIEW_COMMAND")
    [[ -n "$file" ]] && echo "$file" | pbcopy && echo "Copied: $file"
}

# Find directory and copy path to clipboard
fdcp() {
    local dir
    dir=$(find . -type d | fzf --preview "ls -la {}")
    [[ -n "$dir" ]] && echo "$dir" | pbcopy && echo "Copied: $dir"
}

# Multi-file operations
fmv() {
    local files
    files=$(fzf -m --preview "$FZF_PREVIEW_COMMAND")
    [[ -n "$files" ]] && echo "$files" | while read -r file; do
        echo "Moving: $file"
        # Add your move logic here
    done
}

# Search and replace in files
fsr() {
    if ! command -v rg >/dev/null 2>&1; then
        echo "ripgrep (rg) is required for this function"
        return 1
    fi

    local search_term="$1"
    local replace_term="$2"

    if [[ -z "$search_term" ]]; then
        echo "Usage: fsr <search_term> [replace_term]"
        return 1
    fi

    local files
    files=$(rg -l "$search_term" | fzf -m --preview "rg --color=always '$search_term' {}")

    if [[ -n "$files" ]] && [[ -n "$replace_term" ]]; then
        echo "$files" | while read -r file; do
            echo "Replacing in: $file"
            sed -i.bak "s/$search_term/$replace_term/g" "$file"
        done
    fi
}

# Custom fzf function with different layouts
fzf_horizontal() {
    fzf --layout=reverse-list --height=50% --preview="$FZF_PREVIEW_COMMAND" --preview-window=down:50% "$@"
}

fzf_fullscreen() {
    fzf --layout=reverse --height=100% --preview="$FZF_PREVIEW_COMMAND" "$@"
}