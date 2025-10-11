#!/bin/bash

# Git setup script with private configuration support

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_GIT_CONFIG="$HOME/.config/private/git.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📦 Setting up Git configuration...${NC}"

# Create private Git config if it doesn't exist
if [ ! -f "$PRIVATE_GIT_CONFIG" ]; then
    echo -e "${YELLOW}⚠️  Private Git configuration not found${NC}"
    echo "📝 Creating private Git config template..."

    mkdir -p "$(dirname "$PRIVATE_GIT_CONFIG")"

    cat > "$PRIVATE_GIT_CONFIG" << 'EOF'
# Private Git Configuration
# This file contains personal information that should not be shared

[user]
    name = YOUR_NAME
    email = YOUR_EMAIL@example.com

# Add additional private git settings here:
# [credential]
#     helper = store
# [github]
#     user = YOUR_GITHUB_USERNAME
EOF

    echo -e "${GREEN}✅ Private Git config template created at $PRIVATE_GIT_CONFIG${NC}"
    echo -e "${YELLOW}💡 IMPORTANT: Edit $PRIVATE_GIT_CONFIG to set your name and email${NC}"
else
    echo -e "${GREEN}✅ Private Git config already exists${NC}"
fi

# Create symlinks
echo "🔗 Creating symlinks..."
ln -sf "$DOTFILES_DIR/git/gitalias.txt" ~/.gitalias.txt
ln -sf "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig

echo -e "${GREEN}🎉 Git setup complete!${NC}"
echo "📊 Configuration:"
echo "  - Main config: ~/.gitconfig ✅"
echo "  - Alias file: ~/.gitalias.txt ✅"
echo "  - Private config: $PRIVATE_GIT_CONFIG ✅"
echo ""

# Check if private config has been customized
if grep -q "YOUR_NAME" "$PRIVATE_GIT_CONFIG" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  ACTION REQUIRED:${NC}"
    echo "Edit your private Git configuration:"
    echo "  vim $PRIVATE_GIT_CONFIG"
    echo ""
    echo "Update these fields:"
    echo "  - user.name"
    echo "  - user.email"
else
    echo -e "${GREEN}✅ Private Git configuration is set up${NC}"
    echo "👤 Current Git user:"
    git config --get user.name 2>/dev/null && echo "  Name: $(git config --get user.name)" || echo "  Name: [Not set]"
    git config --get user.email 2>/dev/null && echo "  Email: $(git config --get user.email)" || echo "  Email: [Not set]"
fi

echo ""
echo -e "${BLUE}💡 To update user info later:${NC}"
echo "Edit $PRIVATE_GIT_CONFIG or use:"
echo "git config user.name \"Your Name\""
echo "git config user.email \"your.email@example.com\""

