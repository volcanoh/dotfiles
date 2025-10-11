# Git Aliases
# Shell shortcuts for git commands

# Basic git commands
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gf='git fetch'
alias gr='git remote'
alias gm='git merge'
alias gt='git tag'

# Branch operations
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main'
alias gcd='git checkout develop'

# Commit operations
alias gcm='git commit -m'
alias gca='git commit -am'
alias gcam='git commit --amend'
alias gcan='git commit --amend --no-edit'

# Add operations
alias gaa='git add .'
alias gap='git add -p'
alias gau='git add -u'

# Stash operations
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show'

# Log and history
alias glg='git log --oneline --graph --decorate'
alias gll='git log --oneline'
alias glgg='git log --graph --oneline --decorate --all'
alias glp='git log --patch'
alias glo='git log --oneline --decorate'

# Diff operations
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# Push/Pull shortcuts
alias gps='git push'
alias gpsf='git push --force-with-lease'
alias gpsu='git push -u origin HEAD'
alias gpl='git pull'
alias gplr='git pull --rebase'

# Reset operations
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grhu='git reset HEAD@{upstream}'

# Remote operations
alias grv='git remote -v'
alias gra='git remote add'
alias grr='git remote remove'
alias gru='git remote update'

# Clean operations
alias gclean='git clean -fd'
alias gcleanx='git clean -fdx'

# Show operations
alias gsh='git show'
alias gshh='git show HEAD'

# Rebase operations
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'

# Cherry-pick operations
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# Useful git functions
function gclone() {
    git clone "$@" && cd "$(basename "$1" .git)"
}

function gnew() {
    git checkout -b "$1"
}

function gdel() {
    git branch -d "$1" && git push origin --delete "$1"
}

function gfind() {
    git log --all --oneline --grep="$1"
}

# Git flow shortcuts (if you use git flow)
alias gfl='git flow'
alias gfli='git flow init'
alias gflf='git flow feature'
alias gflfs='git flow feature start'
alias gflff='git flow feature finish'
alias gflr='git flow release'
alias gflrs='git flow release start'
alias gflrf='git flow release finish'
