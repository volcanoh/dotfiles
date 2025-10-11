#!/bin/bash

# Zsh setup script with private configuration support

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_CONFIG="$HOME/.config/private/dotfiles.conf"

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

# Create private config if it doesn't exist
if [ ! -f "$PRIVATE_CONFIG" ]; then
    echo -e "${YELLOW}⚠️  Private configuration not found${NC}"
    echo "📝 Creating private config template..."

    mkdir -p "$(dirname "$PRIVATE_CONFIG")"

    cat > "$PRIVATE_CONFIG" << 'EOF'
# Private Configuration for Dotfiles
# This file contains personal/sensitive information that should not be shared
# Simply add 'export VARIABLE="value"' lines - they work immediately after sourcing!

# Git Configuration
export GIT_USER_NAME="YOUR_NAME"
export GIT_USER_EMAIL="YOUR_EMAIL@example.com"

# API Keys and Tokens
# export MODEL_PROXY_TOKEN="your-api-token-here"
# export OPENAI_API_KEY="sk-your-openai-key"
# export GITHUB_TOKEN="ghp_your-github-token"

# Development Environment
# export NODE_ENV="development"
# export PYTHON_PATH="/usr/local/bin/python3"

# Work Configuration
# export WORK_EMAIL="work@company.com"
# export COMPANY_DOMAIN="company.com"

# SSH Configuration
# export SSH_KEY_PATH="~/.ssh/id_rsa"
# export WORK_SSH_KEY="~/.ssh/work_key"

# Add new variables here with export statements:
# export VARIABLE_NAME="value"
EOF

    echo -e "${GREEN}✅ Private config template created at $PRIVATE_CONFIG${NC}"
    echo -e "${YELLOW}💡 IMPORTANT: Edit $PRIVATE_CONFIG to set your information${NC}"
else
    echo -e "${GREEN}✅ Private config already exists${NC}"
fi

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sf "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" ~/.p10k.zsh

echo -e "${GREEN}🎉 Zsh setup complete!${NC}"
echo "📊 Configuration:"
echo "  - Main config: ~/.zshrc ✅"
echo "  - P10k theme: ~/.p10k.zsh ✅"
echo "  - Private config: $PRIVATE_CONFIG ✅"
echo "  - Oh My Zsh: $([ -d "$HOME/.oh-my-zsh" ] && echo "✅" || echo "❌")"
echo "  - Antigen: $([ -f "$HOME/.antigen.zsh" ] && echo "✅" || echo "❌")"
echo ""

# Check if private config has been customized
if grep -q "YOUR_NAME\|YOUR_EMAIL" "$PRIVATE_CONFIG" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  ACTION REQUIRED:${NC}"
    echo "Edit your private configuration:"
    echo "  vim $PRIVATE_CONFIG"
    echo ""
    echo "Update these fields:"
    echo "  - GIT_USER_NAME"
    echo "  - GIT_USER_EMAIL"
    echo "  - Any API keys or tokens you need"
else
    echo -e "${GREEN}✅ Private configuration is set up${NC}"
fi

echo ""
echo -e "${BLUE}💡 How to add new variables:${NC}"
echo "1. Edit $PRIVATE_CONFIG"
echo "2. Add: export VARIABLE_NAME=\"value\""
echo "3. Run: source ~/.zshrc"
echo "4. Test: echo \$VARIABLE_NAME"

echo ""
echo -e "${BLUE}🚀 Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Customize your private config as needed"
