#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

# JetBrains Toolbox — universal installer (works on Fedora too)
TOOLBOX_VERSION="2.5.4.39594"
TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"

log "Installing JetBrains Toolbox..."

if [[ -f "$INSTALL_DIR/bin/jetbrains-toolbox" ]]; then
  warn "JetBrains Toolbox already installed"
  success "Open Toolbox and install PhpStorm from there"
  exit 0
fi

# Fedora dependency for AppImage/Toolbox
sudo dnf install -y fuse fuse-libs libXtst

TMP=$(mktemp -d)
wget -qO "$TMP/toolbox.tar.gz" "$TOOLBOX_URL"
tar -xzf "$TMP/toolbox.tar.gz" -C "$TMP"
mkdir -p "$INSTALL_DIR/bin"
mv "$TMP"/jetbrains-toolbox-*/jetbrains-toolbox "$INSTALL_DIR/bin/"
chmod +x "$INSTALL_DIR/bin/jetbrains-toolbox"
rm -rf "$TMP"

cat > "$HOME/.local/share/applications/jetbrains-toolbox.desktop" << EOF
[Desktop Entry]
Name=JetBrains Toolbox
Exec=$INSTALL_DIR/bin/jetbrains-toolbox
Icon=jetbrains-toolbox
Type=Application
Categories=Development;IDE;
EOF

success "JetBrains Toolbox installed"
warn "Run it once → sign in → install PhpStorm from the UI"
