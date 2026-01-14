#!/usr/bin/env bash

set -e

CONFIG_DIR="$HOME/.config/"
DOTFILES_DIR="$(pwd)/"

echo "Config directory: $CONFIG_DIR"
echo "Dotfiles directory: $DOTFILES_DIR"

CONFIGS=(
    hypr
    waybar
    alacritty
    nvim
    lazygit
    swaync
    yazi
)

mkdir -p "$CONFIG_DIR"

for cfg in "${CONFIGS[@]}"; do
    SRC="$DOTFILES_DIR$cfg"
    DEST="$CONFIG_DIR$cfg"

    if [ ! -e "$SRC" ]; then
        echo "Skipping $cfg not found"
        continue
    fi

    if [ -L "$DEST" ] || [ -e "$DEST" ]; then
        echo "Already exists: $DEST - skipping"
        continue
    fi

    ln -s "$SRC" "$DEST"
    echo "Linked $SRC to $DEST"
done
