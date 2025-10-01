#!/bin/bash
if [[ ! -d ~/.config ]]
then
    mkdir ~/.config
fi

if [[ -d ~/.config/nvim ]]
then
if [[ -d ~/.config/nvim.backup ]]
then
    rm -rf ~/.config/nvim.backup
fi
    echo "mv ~/.config/nvim ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi

ln -sf ~/.dotfiles/nvim ~/.config/nvim

echo "LazyVim setup complete!"
echo "LazyVim will automatically install plugins on first launch."
echo "Optional: Install language servers for better development experience:"
echo "sudo apt install nodejs npm && sudo npm install -g bash-language-server pyright vscode-langservers-extracted typescript typescript-language-server"
