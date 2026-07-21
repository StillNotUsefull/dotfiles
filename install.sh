#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Logging ───────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'

log_ok()   { echo -e "${GREEN}✔${RESET} $*"; }
log_warn() { echo -e "${YELLOW}⚠${RESET}  $*"; }

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

# ── Links ─────────────────────────────────────────────────────────────────────

make_link "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
make_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
make_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
