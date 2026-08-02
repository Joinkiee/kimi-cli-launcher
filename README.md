# Kimi Code Launcher

A Linux desktop entry that lets you launch [Kimi Code CLI](https://github.com/MoonshotAI/kimi-cli) from your applications menu.

It opens a terminal window running `kimi`, complete with the Kimi "K" icon.

## Requirements

- [Kimi Code CLI](https://www.kimi.com/code) installed at `~/.kimi-code/bin/kimi`
- A terminal emulator (default: `xfce4-terminal`)

## Install

```bash
./install.sh
```

Or manually:

```bash
cp kimi.png ~/.local/share/icons/
cp kimi-code.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
```

You should now find **Kimi Code** in your applications menu (under *Development*).

## Customizing

- **Different terminal**: edit the `Exec=` line in `kimi-code.desktop`, e.g. `gnome-terminal -- /home/USER/.kimi-code/bin/kimi` or `konsole -e ...`.
- **Different install path**: if `kimi` lives elsewhere, update the path in `Exec=` accordingly.

## Files

- `kimi-code.desktop` — the desktop entry
- `kimi.png` — the Kimi "K" icon (48×48)
- `install.sh` — copies both files into place
