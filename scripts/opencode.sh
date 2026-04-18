#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

log "Installing OpenCode..."

# OpenCode requires Node.js — ensure nvm is loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if command_exists opencode; then
  warn "OpenCode already installed, upgrading..."
  npm update -g opencode-ai
else
  npm install -g opencode-ai
  success "OpenCode installed: $(opencode --version 2>/dev/null || echo 'installed')"
fi
