#!/bin/bash
# Install the Kimi Code desktop launcher for the current user.
set -e

cd "$(dirname "$0")"

KIMI_BIN="$HOME/.kimi-code/bin/kimi"
KIMI_INSTALL_URL="https://code.kimi.com/kimi-code/install.sh"

# Step 1: make sure Kimi Code CLI is installed.
if [ ! -x "$KIMI_BIN" ]; then
    echo "Kimi Code CLI is not installed on this system."
    echo "This script can install it from the official Kimi site only:"
    echo "  $KIMI_INSTALL_URL"
    printf "Install Kimi Code CLI now? [y/N] "
    read -r answer
    case "$answer" in
        y|Y|yes|YES)
            curl -fsSL "$KIMI_INSTALL_URL" | bash
            ;;
        *)
            echo "Skipped. The menu entry needs Kimi Code CLI to work."
            ;;
    esac
fi

# Step 2: copy the icon and the desktop file.
mkdir -p "$HOME/.local/share/icons" "$HOME/.local/share/applications"
cp kimi.png "$HOME/.local/share/icons/kimi.png"

# Put the current user's home path into the desktop file.
sed -e "s|/home/USER|$HOME|g" kimi-code.desktop \
    > "$HOME/.local/share/applications/kimi-code.desktop"
chmod +x "$HOME/.local/share/applications/kimi-code.desktop"

update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true

echo "Done. Look for 'Kimi Code' in your applications menu."
