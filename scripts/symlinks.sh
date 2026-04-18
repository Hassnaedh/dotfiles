#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# ── Helper: create symlink safely ─────────────────────────────────────────────
link() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backing up existing $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  success "Linked $dst"
}

log "Creating symlinks..."

# Shell
link "$DOTFILES_DIR/config/shell/.zshrc"          "$HOME/.zshrc"
link "$DOTFILES_DIR/config/shell/.bashrc_extra"   "$HOME/.bashrc_extra"
link "$DOTFILES_DIR/config/shell/.aliases"        "$HOME/.aliases"

# Git
link "$DOTFILES_DIR/config/git/.gitconfig"        "$HOME/.gitconfig"
link "$DOTFILES_DIR/config/git/.gitignore_global" "$HOME/.gitignore_global"

# VS Code
VSCODE_DIR="$HOME/.config/Code/User"
mkdir -p "$VSCODE_DIR"
link "$DOTFILES_DIR/config/vscode/settings.json"  "$VSCODE_DIR/settings.json"
link "$DOTFILES_DIR/config/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

# PHP
link "$DOTFILES_DIR/config/php/php.ini.extra"     "$HOME/.php.ini.extra"

# OpenCode
link "$DOTFILES_DIR/config/opencode/config.json"  "$HOME/.config/opencode/config.json"

success "All symlinks created"
