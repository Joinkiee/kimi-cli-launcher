#!/bin/bash
# ==============================================================================
# KIMI CLI LAUNCHER v2.0.0 (Linux)
#
#   1. Checks for a Kimi CLI update (update-kimi.sh) and installs it
#   2. Asks which mode to run (skipped when a mode is passed as $1)
#   3. Asks new chat vs. previous chats
#   4. Launches the CLI
#
#   Usage: kimi-launch.sh [mode] [directory]
#     mode: menu | auto-max | auto | yolo | plan | manual  (default: menu)
# ==============================================================================

VERSION="2.0.0"
MODE="${1:-menu}"
DIR="${2:-$PWD}"
KIMI="$HOME/.kimi-code/bin/kimi"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DIR" 2>/dev/null || cd "$HOME" || exit 1

clear
echo "=============================================================================="
echo " _  ___       _    ___ _    ___"
echo "| |/ (_)_ __ (_)  / __| |  |_ _|"
echo "| ' <| | '  \\| | | (__| |__ | |"
echo "|_|\\_\\_|_|_|_|_|  \\___|____|___|"
echo
echo "                    KIMI CLI LAUNCHER v$VERSION"
echo "=============================================================================="
echo " Folder: $PWD"
echo
echo "=== Update check ==="
if [ -f "$SCRIPT_DIR/update-kimi.sh" ]; then
    bash "$SCRIPT_DIR/update-kimi.sh"
else
    echo "   [SKIP] update-kimi.sh not found"
fi

if [ "$MODE" = "menu" ]; then
    while true; do
        echo
        echo "=== Mode ==="
        echo "   [1] Auto + K3 Max   (auto mode, K3 1M context, max thinking)"
        echo "   [2] Auto            (fully autonomous, never asks)"
        echo "   [3] Yolo            (auto-approve tools, may still ask)"
        echo "   [4] Plan            (plan first, execute after approval)"
        echo "   [5] Manual          (confirm every tool)"
        echo
        read -r -p "Select a mode [1-5]: " PICK
        case "$PICK" in
            1) MODE="auto-max"; break ;;
            2) MODE="auto"; break ;;
            3) MODE="yolo"; break ;;
            4) MODE="plan"; break ;;
            5) MODE="manual"; break ;;
            *) echo "   [!!] Invalid selection - pick 1 to 5." ;;
        esac
    done
fi

ARGS=()
case "$MODE" in
    auto-max)
        # Auto permission mode, K3 model (1M context), max thinking effort.
        ARGS=(--auto -m kimi-code/k3)
        export KIMI_MODEL_THINKING_EFFORT=max
        ;;
    auto)   ARGS=(--auto) ;;
    yolo)   ARGS=(--yolo) ;;
    plan)   ARGS=(--plan) ;;
    manual) ARGS=() ;;
esac

echo
echo "=== Session ==="
echo "   [1] New chat"
echo "   [2] Browse previous chats"
echo
read -r -p "Select [1-2] (default 1): " SPICK
if [ "$SPICK" = "2" ]; then
    ARGS+=(--session)
fi

echo
echo "=============================================================================="
if [ ${#ARGS[@]} -gt 0 ]; then
    echo " Launching: kimi ${ARGS[*]}"
else
    echo " Launching: kimi"
fi
echo "=============================================================================="
echo

"$KIMI" "${ARGS[@]}"
STATUS=$?
if [ $STATUS -ne 0 ]; then
    echo
    read -r -p "Kimi exited with an error. Press Enter to close."
fi
exit $STATUS
