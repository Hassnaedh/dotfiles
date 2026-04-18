#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

log "Configuring Git..."

# Prompt only if not already set
NAME=$(git config --global user.name 2>/dev/null || true)
EMAIL=$(git config --global user.email 2>/dev/null || true)

if [[ -z "$NAME" ]]; then
  read -rp "  Git username: " NAME
fi
if [[ -z "$EMAIL" ]]; then
  read -rp "  Git email: " EMAIL
fi

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
git config --global core.editor "nano"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global push.autoSetupRemote true
git config --global core.autocrlf input       # LF on Linux
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --decorate --all"
git config --global alias.undo "reset --soft HEAD~1"
git config --global color.ui auto

success "Git configured for $NAME <$EMAIL>"
