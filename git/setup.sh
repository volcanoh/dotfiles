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
echo "📊 Current configuration:"
git config --get user.name
git config --get user.email

echo ""
echo -e "${YELLOW}💡 To change user info:${NC}"
echo "git config user.name \"Your Name\""
echo "git config user.email \"your.email@example.com\""

