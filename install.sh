#!/bin/bash
# Install the Kimi Code desktop launcher for the current user.
set -e

cd "$(dirname "$0")"

# Adjust this if your terminal or kimi path differs.
KIMI_BIN="$HOME/.kimi-code/bin/kimi"

if [ ! -x "$KIMI_BIN" ]; then
    echo "warning: kimi not found at $KIMI_BIN" >&2
    echo "the launcher will still be installed, but update Exec= in kimi-code.desktop" >&2
fi

mkdir -p "$HOME/.local/share/icons" "$HOME/.local/share/applications"
cp kimi.png "$HOME/.local/share/icons/kimi.png"

# Rewrite the Exec/Icon paths for the current user, then install.
sed -e "s|/home/USER|$HOME|g" kimi-code.desktop \
    > "$HOME/.local/share/applications/kimi-code.desktop"
chmod +x "$HOME/.local/share/applications/kimi-code.desktop"

update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true

echo "Installed. Look for 'Kimi Code' in your applications menu."
