#!/bin/sh
set -eu
repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
bin_dir=${1:-"$HOME/.local/bin"}
mkdir -p "$bin_dir"
target="$bin_dir/getting_started"
if [ -e "$target" ] && [ ! -L "$target" ]; then
    printf 'Already exists: %s\n' "$target" >&2
    exit 1
fi
ln -sfn "$repo/getting_started" "$target"
case ":$PATH:" in
    *":$bin_dir:"*) printf 'Installed getting_started.\n' ;;
    *)
        # Codespaces sets PATH in devcontainer.json. Local shells need it once.
        for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
            line="export PATH=\"\$PATH:$bin_dir\""
            if ! grep -Fqx "$line" "$profile" 2>/dev/null; then
                printf '\n%s\n' "$line" >> "$profile"
            fi
        done
        printf 'Installed getting_started. Open a new terminal.\n'
        ;;
esac
