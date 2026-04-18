#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

log "Installing Visual Studio Code..."

if command_exists code; then
  warn "VS Code already installed"
else
  # Add Microsoft repo for Fedora (rpm)
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'cat > /etc/yum.repos.d/vscode.repo << EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF'
  sudo dnf install -y code
  success "VS Code installed"
fi

# ── Extensions ────────────────────────────────────────────────────────────────
log "Installing VS Code extensions..."
EXTENSIONS=(
  bmewburn.vscode-intelephense-client
  xdebug.php-debug
  onecentlin.laravel-blade
  amiralizadeh9480.laravel-extra-intellisense
  dbaeumer.vscode-eslint
  esbenp.prettier-vscode
  bradlc.vscode-tailwindcss
  ms-vscode.vscode-typescript-next
  eamodio.gitlens
  mhutchie.git-graph
  editorconfig.editorconfig
  pkief.material-icon-theme
  zhuangtongfa.material-theme
  aaron-bond.better-comments
  streetsidesoftware.code-spell-checker
  formulahendry.auto-rename-tag
  christian-kohler.path-intellisense
  rangav.vscode-thunder-client
)

for ext in "${EXTENSIONS[@]}"; do
  code --install-extension "$ext" --force 2>/dev/null && success "$ext" || warn "Could not install $ext"
done

success "VS Code ready"
