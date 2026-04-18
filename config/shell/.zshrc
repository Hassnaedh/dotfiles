# ──────────────────────────────────────────────────────────────────────────────
#  .zshrc  —  managed by dotfiles
# ──────────────────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z                      # jump to frecent dirs
  composer
  npm
  node
  php
  docker
  docker-compose
)

source "$ZSH/oh-my-zsh.sh"

# ── nvm ───────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]         && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── PATH additions ────────────────────────────────────────────────────────────
export PATH="$HOME/.config/composer/vendor/bin:$PATH"   # Composer globals
export PATH="$HOME/.local/bin:$PATH"                    # Pip / local installs
export PATH="$HOME/.local/share/JetBrains/Toolbox/bin:$PATH"  # JetBrains Toolbox

# ── PHP ───────────────────────────────────────────────────────────────────────
export PHP_CS_FIXER_IGNORE_ENV=1

# ── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="nano"
export VISUAL="code"

# ── Aliases ───────────────────────────────────────────────────────────────────
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ── Powerlevel10k instant prompt (keep at bottom) ────────────────────────────
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
