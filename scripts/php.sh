#!/usr/bin/env bash
source "$(dirname "$0")/_helpers.sh"

# ── Config — edit these to add/remove versions ────────────────────────────────
PHP_VERSIONS=("8.2" "8.3" "8.4")
PHP_DEFAULT="8.3"
# ─────────────────────────────────────────────────────────────────────────────

EXTENSIONS=(
  cli
  fpm
  mbstring
  xml
  curl
  zip
  bcmath
  intl
  gd
  mysqlnd
  pgsql
  pdo
  sqlite
  pecl-redis
  pecl-xdebug
)

log "Installing Remi repository (PHP source for Fedora)..."
sudo dnf install -y "https://rpms.remirepo.net/fedora/remi-release-43.rpm" 2>/dev/null || \
sudo dnf install -y "https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm"
sudo dnf install -y dnf-plugins-core

for VERSION in "${PHP_VERSIONS[@]}"; do
  SHORT="${VERSION//.}"   # "8.3" → "83"
  log "Installing PHP ${VERSION}..."

  PKGS=("php${SHORT}")
  for EXT in "${EXTENSIONS[@]}"; do
    PKGS+=("php${SHORT}-php-${EXT}")
  done

  sudo dnf install -y --repo "remi-php${SHORT}" "${PKGS[@]}" 2>/dev/null || \
  sudo dnf module install -y "php:remi-${VERSION}" && \
  sudo dnf install -y "${PKGS[@]}"

  success "PHP ${VERSION} installed"
done

# ── Set default version via alternatives ─────────────────────────────────────
log "Setting PHP ${PHP_DEFAULT} as default..."
DEFAULT_SHORT="${PHP_DEFAULT//.}"
sudo alternatives --set php "/usr/bin/php${DEFAULT_SHORT}" 2>/dev/null || \
sudo update-alternatives --set php "/usr/bin/php${DEFAULT_SHORT}" 2>/dev/null || true
success "Default PHP → $(php -r 'echo PHP_VERSION;' 2>/dev/null || echo "$PHP_DEFAULT")"

# ── Composer ──────────────────────────────────────────────────────────────────
if command_exists composer; then
  warn "Composer already installed, updating..."
  composer self-update
else
  log "Installing Composer..."
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [[ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]]; then
    error "Composer installer checksum mismatch!"
    rm composer-setup.php
    exit 1
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
  sudo mv composer.phar /usr/local/bin/composer
  sudo chmod +x /usr/local/bin/composer
  success "Composer installed"
fi

# ── Global Composer packages ──────────────────────────────────────────────────
log "Installing global Composer packages..."
PACKAGES=(
  laravel/installer
  squizlabs/php_codesniffer
  phpstan/phpstan
)

for pkg in "${PACKAGES[@]}"; do
  composer global require "$pkg" --quiet && success "$pkg" || warn "Failed: $pkg"
done

echo ""
log "Switch PHP version anytime with:"
for VERSION in "${PHP_VERSIONS[@]}"; do
  SHORT="${VERSION//.}"
  echo "   sudo alternatives --set php /usr/bin/php${SHORT}"
done
