#!/usr/bin/env bash
set -e

# ─────────────────────────────────────────────
#  dotfiles installer — Fedora 43+
#  Usage: curl -fsSL https://raw.githubusercontent.com/Hassnaedh/dotfiles/main/install.sh | bash
#  Or:    git clone https://github.com/Hassnaedh/dotfiles && cd dotfiles && ./install.sh
# ─────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_USER="Hassnaedh"
DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()     { echo -e "${BLUE}[dotfiles]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# ── Verify we are on Fedora ───────────────────────────────────────────────────
if ! command -v dnf &>/dev/null; then
  error "This script is for Fedora only (dnf not found)."
fi

# ── 0. Clone if running via curl ──────────────────────────────────────────────
if [[ ! -f "$DOTFILES_DIR/install.sh" ]]; then
  log "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  DOTFILES_DIR="$HOME/.dotfiles"
fi

log "Starting full environment setup on Fedora..."
echo ""

# ── 1. Core dnf packages ──────────────────────────────────────────────────────
log "Updating dnf and installing core packages..."
sudo dnf upgrade -y --quiet
sudo dnf install -y \
  git curl wget unzip zip \
  gcc gcc-c++ make \
  ca-certificates gnupg2 \
  zsh tmux htop tree jq \
  xclip xdg-utils \
  util-linux-user
success "Core packages installed"

# ── 2. Git config ─────────────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/git.sh"

# ── 3. Zsh + Oh My Zsh ───────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/zsh.sh"

# ── 4. Node.js via nvm ───────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/node.sh"

# ── 5. PHP + Composer ────────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/php.sh"

# ── 6. VS Code ───────────────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/vscode.sh"

# ── 7. PhpStorm ──────────────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/phpstorm.sh"

# ── 8. OpenCode ──────────────────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/opencode.sh"

# ── 9. Symlink all dotfiles ───────────────────────────────────────────────────
bash "$DOTFILES_DIR/scripts/symlinks.sh"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup complete! Restart your terminal  ${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
warn "Run 'chsh -s \$(which zsh)' to make zsh your default shell"
warn "Then log out and back in, or run: exec zsh"
