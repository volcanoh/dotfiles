#!/bin/bash

# Git setup script - simplified version with no template processing

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔧 Setting up git configuration..."

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sf "$DOTFILES_DIR/git/gitalias.txt" ~/.gitalias.txt
ln -sf "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig

echo -e "${GREEN}🎉 Git setup complete!${NC}"
echo "📊 Git configuration:"
echo "  - Config file: ~/.gitconfig (symlinked)"
echo "  - Aliases: ~/.gitalias.txt (symlinked)"
echo "  - Private config: ~/.config/private/git.conf"

echo ""
echo "👤 Current user configuration:"
git config --get user.name 2>/dev/null && echo "  Name: $(git config --get user.name)" || echo "  Name: [Not set]"
git config --get user.email 2>/dev/null && echo "  Email: $(git config --get user.email)" || echo "  Email: [Not set]"

echo ""
echo -e "${YELLOW}💡 To change user info:${NC}"
echo "Edit ~/.config/private/git.conf or use:"
echo "git config user.name \"Your Name\""
echo "git config user.email \"your.email@example.com\""

