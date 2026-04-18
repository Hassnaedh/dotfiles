#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

NVM_VERSION="0.40.3"
NODE_VERSION="22"

# Fedora: make sure curl and tar are available (needed by nvm)
sudo dnf install -y curl tar --quiet

log "Installing nvm v${NVM_VERSION}..."
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
  success "nvm installed"
else
  warn "nvm already present, skipping"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

log "Installing Node.js LTS (v${NODE_VERSION})..."
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
success "Node $(node -v) / npm $(npm -v) ready"

log "Installing global npm packages..."
PACKAGES=(
  yarn
  pnpm
  typescript
  ts-node
  nodemon
  eslint
  prettier
)

for pkg in "${PACKAGES[@]}"; do
  npm install -g "$pkg" --quiet && success "$pkg" || warn "Failed: $pkg"
done
