# dotfiles

My personal Linux development environment — one command to go from a fresh Ubuntu install to a fully configured workstation.

## What gets installed

| Category | Tools |
|---|---|
| Shell | Zsh, Oh My Zsh, Powerlevel10k, autosuggestions, syntax highlighting |
| Version control | Git (configured with aliases + global .gitignore) |
| Node.js | nvm, Node LTS, npm globals (yarn, pnpm, typescript, eslint, prettier) |
| PHP | PHP 8.3 + common extensions, Composer, Laravel installer, PHPStan |
| Editors | VS Code (+ extensions), JetBrains Toolbox (→ PhpStorm), OpenCode |
| Dotfiles | All configs symlinked into `~` — edit once, apply everywhere |

---

## Quick start (fresh Ubuntu/Debian)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash
```

Or clone manually:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

After install:

```bash
chsh -s $(which zsh)    # make zsh your default shell
# then log out and back in
```

---

## Repo structure

```
dotfiles/
├── install.sh                  ← entry point
├── scripts/
│   ├── _helpers.sh             ← shared log/success/warn functions
│   ├── git.sh                  ← git config (prompts for name/email)
│   ├── zsh.sh                  ← zsh + oh-my-zsh + plugins + p10k
│   ├── node.sh                 ← nvm + Node LTS + global npm packages
│   ├── php.sh                  ← PHP 8.3 + extensions + Composer + globals
│   ├── vscode.sh               ← VS Code + extensions
│   ├── phpstorm.sh             ← JetBrains Toolbox (install PhpStorm from UI)
│   ├── opencode.sh             ← OpenCode CLI
│   └── symlinks.sh             ← symlinks all config files into ~
└── config/
    ├── shell/
    │   ├── .zshrc              ← zsh config + PATH exports
    │   └── .aliases            ← all shell aliases
    ├── git/
    │   ├── .gitconfig          ← git settings + aliases
    │   └── .gitignore_global   ← global gitignore
    ├── vscode/
    │   ├── settings.json       ← VS Code settings
    │   └── keybindings.json    ← VS Code keybindings
    ├── php/
    │   └── php.ini.extra       ← extra PHP ini directives
    └── opencode/
        └── config.json         ← OpenCode config
```

---

## Updating dotfiles

Since everything is symlinked, editing any file in `~/.dotfiles/config/` takes effect immediately. To pull changes from GitHub:

```bash
cd ~/.dotfiles && git pull
```

To re-run just the symlinks (e.g. after adding a new config file):

```bash
cd ~/.dotfiles && bash scripts/symlinks.sh
```

---

## Customising

### Change PHP version
Edit `PHP_VERSION` at the top of `scripts/php.sh`.

### Change Node version
Edit `NODE_VERSION` at the top of `scripts/node.sh`.

### Add/remove VS Code extensions
Edit the `EXTENSIONS` array in `scripts/vscode.sh`.

### Add npm globals
Edit the `PACKAGES` array in `scripts/node.sh`.

### Add Composer globals
Edit the `PACKAGES` array in `scripts/php.sh`.

### Add shell aliases
Edit `config/shell/.aliases` — no restart needed, just `source ~/.aliases`.

---

## Saving your existing Windows config before switching

Before moving to Linux, export from Windows:

```powershell
# VS Code extensions list
code --list-extensions > vscode-extensions.txt

# VS Code settings
copy "%APPDATA%\Code\User\settings.json" .

# Git config
copy "%USERPROFILE%\.gitconfig" .
```

Then paste relevant settings into the corresponding files in this repo.

---

## Tips

- Run individual scripts to update a single tool: `bash scripts/node.sh`
- PhpStorm: after Toolbox installs it, your settings can be synced via JetBrains Settings Sync (built into the IDE)
- The `.gitconfig` in this repo does NOT include `user.name`/`user.email` — `scripts/git.sh` sets those via `git config --global` so they stay out of the repo
