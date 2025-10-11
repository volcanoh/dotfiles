#!/bin/bash

# Zsh setup script - simplified version with no template processing

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_CONFIG="$HOME/.config/private/dotfiles.conf"
PRIVATE_TEMPLATE="$DOTFILES_DIR/config/private.conf.template"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐚 Setting up zsh configuration...${NC}"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Antigen if not present
if [ ! -f "$HOME/.antigen.zsh" ]; then
    echo "📦 Installing Antigen..."
    curl -L git.io/antigen > ~/.antigen.zsh
fi

# Check if private config exists, create if missing
if [ ! -f "$PRIVATE_CONFIG" ]; then
    echo -e "${YELLOW}⚠️  Private configuration not found at $PRIVATE_CONFIG${NC}"
    echo "📝 Creating private config from template..."

    mkdir -p "$(dirname "$PRIVATE_CONFIG")"

    if [ -f "$PRIVATE_TEMPLATE" ]; then
        cp "$PRIVATE_TEMPLATE" "$PRIVATE_CONFIG"
        echo -e "${GREEN}✅ Private config created at $PRIVATE_CONFIG${NC}"
        echo -e "${YELLOW}💡 Edit the private config with your information${NC}"
    else
        echo -e "${RED}❌ Template not found at $PRIVATE_TEMPLATE${NC}"
        exit 1
    fi
fi

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sf "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" ~/.p10k.zsh

echo -e "${GREEN}🎉 Zsh setup complete!${NC}"
echo "📊 Configuration:"
echo "  - Private config sourcing: ✅"
echo "  - Oh My Zsh integration: ✅"
echo "  - Powerlevel10k theme: ✅"
echo ""
echo -e "${BLUE}💡 How to add new variables:${NC}"
echo "1. Edit $PRIVATE_CONFIG"
echo "2. Add: export VARIABLE_NAME=\"value\""
echo "3. Run: source ~/.zshrc"
echo "4. Test: echo \$VARIABLE_NAME"
