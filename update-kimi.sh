#!/bin/bash
# Update Kimi Code CLI to the latest version if a newer one exists.
# Called by kimi-launch.sh before every launch. Prints one line and exits 0.
KIMI="$HOME/.kimi-code/bin/kimi"
BASE="https://code.kimi.com/kimi-code"

# latest.json is the rollout manifest. /latest is the plain-text fallback.
LATEST=""
JSON=$(curl -fsSL --max-time 10 "$BASE/latest.json" 2>/dev/null) || JSON=""
if [ -n "$JSON" ]; then
    LATEST=$(printf '%s' "$JSON" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi
if [ -z "$LATEST" ]; then
    LATEST=$(curl -fsSL --max-time 10 "$BASE/latest" 2>/dev/null | tr -d '[:space:]')
fi
[ -z "$LATEST" ] && exit 0

CURRENT=""
if [ -x "$KIMI" ]; then
    CURRENT=$("$KIMI" --version 2>/dev/null | tr -d '[:space:]')
fi

if [ "$LATEST" = "$CURRENT" ]; then
    echo "   [OK] Kimi CLI is up to date ($CURRENT)"
    exit 0
fi

echo "   [..] Updating Kimi CLI: $CURRENT -> $LATEST"
if curl -fsSL "$BASE/install.sh" | bash; then
    echo "   [OK] Kimi CLI updated to $LATEST"
else
    echo "   [WARN] update failed; starting the current version."
fi
exit 0
