# FZF Configuration
# Custom fzf setup without conflicting key bindings

# Check if fzf is available
if ! command -v fzf >/dev/null 2>&1; then
    return
fi

# FZF Default Options
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--info=inline
--prompt='🔍 '
--pointer='▶'
--marker='✓'
--bind 'ctrl-y:execute-silent(echo {} | pbcopy)'
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-j:down'
--bind 'ctrl-k:up'
--preview-window=right:60%:wrap
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6fc,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6fc,hl+:#f38ba8
"

# Default command (uses fd if available, fallback to find)
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'
fi

# Preview commands
if command -v bat >/dev/null 2>&1; then
    export FZF_PREVIEW_COMMAND='bat --color=always --style=numbers --line-range=:500 {}'
elif command -v highlight >/dev/null 2>&1; then
    export FZF_PREVIEW_COMMAND='highlight -O ansi -l {} 2> /dev/null | head -500'
else
    export FZF_PREVIEW_COMMAND='head -500 {}'
fi

# Load FZF completion only (no automatic key bindings)
local fzf_completion=""

# Auto-detect FZF installation path
if [[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ]]; then
    fzf_completion="/opt/homebrew/opt/fzf/shell/completion.zsh"
elif [[ -f "/usr/local/opt/fzf/shell/completion.zsh" ]]; then
    fzf_completion="/usr/local/opt/fzf/shell/completion.zsh"
elif [[ -f "/opt/homebrew/share/fzf/shell/completion.zsh" ]]; then
    fzf_completion="/opt/homebrew/share/fzf/shell/completion.zsh"
elif [[ -f "/usr/local/share/fzf/shell/completion.zsh" ]]; then
    fzf_completion="/usr/local/share/fzf/shell/completion.zsh"
elif [[ -f "/usr/share/fzf/completion.zsh" ]]; then
    fzf_completion="/usr/share/fzf/completion.zsh"
fi

# Load completion only
[[ -n "$fzf_completion" && -f "$fzf_completion" ]] && source "$fzf_completion"

unset fzf_completion