#!/bin/bash
# Install the Kimi CLI desktop launcher for the current user.
set -e

cd "$(dirname "$0")"

KIMI_BIN="$HOME/.kimi-code/bin/kimi"
KIMI_INSTALL_URL="https://code.kimi.com/kimi-code/install.sh"
LAUNCHER_DIR="$HOME/.local/share/kimi-cli-launcher"

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

# Step 2: copy the launcher, the updater, and the icon.
mkdir -p "$LAUNCHER_DIR" "$HOME/.local/share/icons" "$HOME/.local/share/applications"
cp kimi-launch.sh update-kimi.sh "$LAUNCHER_DIR/"
chmod +x "$LAUNCHER_DIR/kimi-launch.sh" "$LAUNCHER_DIR/update-kimi.sh"
cp kimi.png "$HOME/.local/share/icons/kimi.png"

# Put the current user's home path into the desktop file.
sed -e "s|/home/USER|$HOME|g" kimi-code.desktop \
    > "$HOME/.local/share/applications/kimi-code.desktop"
chmod +x "$HOME/.local/share/applications/kimi-code.desktop"

update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true

# Step 3: Thunar right-click menu (custom actions), idempotent.
UCA_FILE="$HOME/.config/Thunar/uca.xml"
if command -v thunar >/dev/null; then
    mkdir -p "$HOME/.config/Thunar"
    UCA_BLOCK=$(sed -e "s|/home/USER|$HOME|g" kimi-uca.xml)
    if [ -f "$UCA_FILE" ]; then
        # Drop any previous Kimi block, then insert the fresh one.
        sed -i '/<!-- KIMI-CLI-START -->/,/<!-- KIMI-CLI-END -->/d' "$UCA_FILE"
        awk -v block="$UCA_BLOCK" '/<\/actions>/ && !done {print block; done=1} {print}' \
            "$UCA_FILE" > "$UCA_FILE.tmp" && mv "$UCA_FILE.tmp" "$UCA_FILE"
    else
        printf '<?xml version="1.0" encoding="UTF-8"?>\n<actions>\n%s</actions>\n' \
            "$UCA_BLOCK" > "$UCA_FILE"
    fi
    # Make Thunar reload its custom actions.
    thunar -q 2>/dev/null || true
fi

echo "Done. Look for 'Kimi CLI' in your applications menu."
echo "Every launch checks for a Kimi CLI update and asks which mode to use."
echo "Right-click a folder (or inside one) in Thunar for the 'Kimi CLI' submenu."
