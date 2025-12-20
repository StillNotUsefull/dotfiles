#!/usr/bin/env bash

# Exit immediately if:
# - a command exits with a non-zero status (-e)
# - an unset variable is used (-u)
# - any command in a pipeline fails (-o pipefail)
set -euo pipefail

# Resolve the absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Using dotfiles directory: $DOTFILES_DIR"

# --------------------------------------------------
# Install Homebrew (macOS package manager)
# --------------------------------------------------

# Check whether Homebrew is already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Homebrew not found; installing Homebrew"

  # Official Homebrew installation command
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Ensure brew is available in the current shell session
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "==> Homebrew already installed"
fi

# --------------------------------------------------
# Install required packages via Homebrew
# --------------------------------------------------

echo "==> Installing required packages"

# Install GNU Stow if missing
if ! command -v stow >/dev/null 2>&1; then
  brew install stow
else
  echo "==> stow already installed"
fi

# Install Neovim if missing
if ! command -v nvim >/dev/null 2>&1; then
  brew install neovim
else
  echo "==> neovim already installed"
fi

# Install WezTerm if missing
if ! command -v wezterm >/dev/null 2>&1; then
  brew install --cask wezterm
else
  echo "==> wezterm already installed"
fi

# --------------------------------------------------
# Stow dotfiles
# --------------------------------------------------

echo "==> Stowing dotfiles"

# Change to dotfiles directory so relative paths are correct
cd "$DOTFILES_DIR"

# Ensure Neovim config target directory exists
mkdir -p "$HOME/.config/nvim"

# Stow Neovim configuration
# This links files from:
#   $DOTFILES_DIR/nvim
# into:
#   ~/.config/nvim
stow -d "$DOTFILES_DIR" -t "$HOME/.config/nvim" nvim

# Ensure WezTerm config target directory exists
mkdir -p "$HOME/.config/wezterm"

# Stow WezTerm configuration
# This links files from:
#   $DOTFILES_DIR/wezterm
# into:
#   ~/.config/wezterm
stow -d "$DOTFILES_DIR" -t "$HOME/.config/wezterm" wezterm

echo "==> Dotfiles installation complete"

