#!/bin/bash
set -euo pipefail

TARGET="$HOME"

# Traverses all directories except "vars/"
for dir in */; do
    [ "$dir" = "vars/" ] && continue

    echo "Synchronizing $dir..."
    stow --adopt "${dir%/}"
done

echo "Dotfiles synchronized!"
