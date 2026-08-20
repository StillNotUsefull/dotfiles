#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Logging ───────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'

log_ok()   { echo -e "${GREEN}✔${RESET} $*"; }
log_warn() { echo -e "${YELLOW}⚠${RESET}  $*"; }

# ── Wallpaper ─────────────────────────────────────────────────────────────────

WALLPAPER="$DOTFILES_DIR/wallpapers/evening-sky.png"

osascript -e 'tell application "Finder"' \
  -e "set desktop picture to POSIX file \"$WALLPAPER\"" \
  -e 'end tell'

# ── Symlink helper ────────────────────────────────────────────────────────────
# Usage: make_link <source> <target>
# Backs up any existing file/link before creating the symlink.

make_link() {
  local src="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
    log_ok "already linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.bak_$(date +%Y%m%d_%H%M%S)"
    log_warn "backing up $target → $backup"
    mv "$target" "$backup"
  fi

  ln -sf "$src" "$target"
  log_ok "$target → $src"
}

# ── Homebrew ──────────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
  log_warn "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log_ok "Homebrew already installed"
fi

BREW_TAPS=(
  nikitabobko/tap
  FelixKratz/formulae
)

BREW_PACKAGES=(
  neovim
  tmux
  ripgrep
  node
  go
  tree-sitter-cli
)

BREW_CASKS=(
  ghostty
  obsidian
  font-jetbrains-mono-nerd-font
  aerospace
)

for tap in "${BREW_TAPS[@]+"${BREW_TAPS[@]}"}"; do
  brew tap "$tap"
  brew trust nikitabobko/tap
  log_ok "tapped: $tap"
done

for pkg in "${BREW_PACKAGES[@]+"${BREW_PACKAGES[@]}"}"; do
  if brew list --formula "$pkg" &>/dev/null; then
    log_ok "already installed: $pkg"
  else
    log_warn "installing: $pkg"
    brew install "$pkg"
  fi
done

for pkg in "${BREW_CASKS[@]+"${BREW_CASKS[@]}"}"; do
  if brew list --cask "$pkg" &>/dev/null; then
    log_ok "already installed: $pkg"
  else
    log_warn "installing: $pkg"
    brew install --cask "$pkg"
  fi
done

# ── Rust ──────────────────────────────────────────────────────────────────────

if command -v rustc &>/dev/null; then
  log_ok "Rust already installed"
else
  log_warn "Rust not found, installing via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  rustup component add rust-analyzer
fi

# ── Links ─────────────────────────────────────────────────────────────────────

make_link "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
make_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
make_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
make_link "$DOTFILES_DIR/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
