# Zsh Configuration Settings
# Core zsh options and configurations (loaded after Oh My Zsh)

# History settings (additional to main config)
setopt HIST_IGNORE_DUPS          # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entries
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_VERIFY               # Show command with history expansion
setopt SHARE_HISTORY             # Share history between sessions
setopt EXTENDED_HISTORY          # Record timestamp of command
setopt APPEND_HISTORY            # Append to history file
setopt INC_APPEND_HISTORY        # Write to history file immediately

# Directory options
setopt AUTO_CD                   # Auto change to directory without cd
setopt AUTO_PUSHD                # Push directories to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicate directories
setopt PUSHD_SILENT              # Don't print directory stack

# Completion options
setopt AUTO_MENU                 # Show completion menu on tab
setopt AUTO_LIST                 # Automatically list choices
setopt AUTO_PARAM_SLASH          # Add slash after directory names
setopt COMPLETE_IN_WORD          # Complete from both ends of word
setopt ALWAYS_TO_END             # Move cursor to end of completed word

# Globbing options
setopt EXTENDED_GLOB             # Extended globbing patterns
setopt GLOB_DOTS                 # Include dotfiles in globbing
setopt NO_CASE_GLOB              # Case insensitive globbing

# Other useful options
setopt CORRECT                   # Command correction
setopt NO_BEEP                   # No beep on error
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell
setopt LONG_LIST_JOBS            # List jobs in long format
setopt NOTIFY                    # Report status of background jobs immediately

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Vi mode
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^F' history-incremental-search-forward

# Restore common emacs-style key bindings in vi mode
bindkey '^P' up-line-or-history      # Ctrl-P: Previous command
bindkey '^N' down-line-or-history    # Ctrl-N: Next command
bindkey '^A' beginning-of-line       # Ctrl-A: Beginning of line
bindkey '^E' end-of-line             # Ctrl-E: End of line
bindkey '^K' kill-line               # Ctrl-K: Kill to end of line
bindkey '^U' backward-kill-line      # Ctrl-U: Kill to beginning of line
bindkey '^W' backward-kill-word      # Ctrl-W: Kill previous word
bindkey '^Y' yank                    # Ctrl-Y: Yank (paste)

# Auto-suggestions configuration (only if plugin is loaded)
if [[ -n "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-}" ]]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Syntax highlighting configuration (only if plugin is loaded)
if [[ -n "${ZSH_HIGHLIGHT_HIGHLIGHTERS:-}" ]]; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
fi

# Completion system
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion menu
zstyle ':completion:*' menu select

# Group completion results
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Colors in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Better completion for cd
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# Kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# SSH completion
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} /dev/null)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# Load additional configuration files
for config_file in ~/.dotfiles/zsh/config/*.zsh; do
    [[ -r "$config_file" && "$(basename "$config_file")" != "main.zsh" ]] && source "$config_file"
done