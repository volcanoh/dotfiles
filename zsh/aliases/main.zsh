# Shell Aliases
# This file contains useful shell aliases

# Improved ls commands
if command -v exa >/dev/null 2>&1; then
    alias ls='exa --icons'
    alias ll='exa -l --icons --git'
    alias la='exa -la --icons --git'
    alias lt='exa --tree --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Git aliases (complement the git aliases in gitconfig)
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gr='git remote'
alias gm='git merge'
alias gt='git tag'
alias gst='git stash'

# Git shortcuts for common workflows
alias gaa='git add .'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gps='git push'
alias gpl='git pull'
alias gst='git status'
alias glg='git log --oneline --graph --decorate'
alias gll='git log --oneline'

# Editor aliases
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
fi

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# Better cat with syntax highlighting
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
    alias less='bat'
fi

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Network utilities
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s http://checkip.amazonaws.com'
alias localip='ipconfig getifaddr en0 || hostname -I | cut -d" " -f1'

# System information
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop 2>/dev/null || top'

# Archive utilities
alias tarx='tar -xvf'
alias tarc='tar -cvf'
alias tarz='tar -czvf'
alias untar='tar -xvf'

# Docker aliases
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlogs='docker logs'
    alias dstop='docker stop $(docker ps -q)'
    alias drm='docker rm $(docker ps -aq)'
    alias drmi='docker rmi $(docker images -q)'
    alias dprune='docker system prune -af'
fi

# Kubernetes aliases
if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kdp='kubectl describe pod'
    alias kds='kubectl describe service'
    alias kdd='kubectl describe deployment'
    alias kaf='kubectl apply -f'
    alias kdel='kubectl delete'
    alias klog='kubectl logs'
    alias kexec='kubectl exec -it'
fi

# Python aliases
if command -v python3 >/dev/null 2>&1; then
    alias python='python3'
    alias pip='pip3'
fi

# Node.js aliases
if command -v node >/dev/null 2>&1; then
    alias npm-list='npm list -g --depth=0'
    alias npm-update='npm update -g'
    alias npm-clean='npm cache clean --force'
fi

# Tmux aliases
if command -v tmux >/dev/null 2>&1; then
    alias t='tmux'
    alias ta='tmux attach'
    alias tl='tmux list-sessions'
    alias tn='tmux new-session'
    alias tk='tmux kill-session'
fi

# Quick config edits
alias zshrc='$EDITOR ~/.zshrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'
alias tmuxrc='$EDITOR ~/.tmux.conf'
alias gitrc='$EDITOR ~/.gitconfig'

# Quick directory jumps (customize these for your workflow)
alias dotfiles='cd ~/.dotfiles'
alias projects='cd ~/Projects'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop'

# Utility functions as aliases
alias weather='curl wttr.in'
alias cheat='curl cheat.sh'
alias qr='qrencode -t UTF8'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Quick system updates
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias update='brew update && brew upgrade'
    alias cleanup='brew cleanup'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt >/dev/null 2>&1; then
        alias update='sudo apt update && sudo apt upgrade'
        alias install='sudo apt install'
        alias search='apt search'
    elif command -v yum >/dev/null 2>&1; then
        alias update='sudo yum update'
        alias install='sudo yum install'
        alias search='yum search'
    elif command -v pacman >/dev/null 2>&1; then
        alias update='sudo pacman -Syu'
        alias install='sudo pacman -S'
        alias search='pacman -Ss'
    fi
fi

# Development server shortcuts
alias serve='python3 -m http.server 8000'
alias liveserver='live-server --port=8080'

# File permissions
alias chx='chmod +x'
alias 644='chmod 644'
alias 755='chmod 755'
alias 777='chmod 777'

# Process management
alias psg='ps aux | grep'
alias kill9='kill -9'
alias killall='killall'

# Miscellaneous
alias c='clear'
alias h='history'
alias j='jobs'
alias path='echo $PATH | tr ":" "\n"'
alias reload='source ~/.zshrc'