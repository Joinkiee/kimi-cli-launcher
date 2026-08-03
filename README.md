# Kimi CLI Launcher

Adds Kimi CLI to the applications menu on Linux and the Start Menu on Windows.
Made for Linux Mint and Windows 10/11.

## What it does

- Puts "Kimi CLI" in your applications menu or Start Menu, with the Kimi "K" icon.
- Opens a terminal and starts Kimi Code CLI when you click it.

## Requirements

- Linux Mint (22.x tested) with `xfce4-terminal`, or Windows 10/11 with PowerShell.
  Windows Terminal is used if it is installed, otherwise `cmd.exe`.
- Kimi Code CLI. If it is missing, the installer offers to install it from the
  official Kimi site only (`https://code.kimi.com/kimi-code/install.sh` on Linux,
  `install.ps1` on Windows). It asks before installing anything.

## Install

Clone this repository and go into the folder. Then:

- Linux: run `./install.sh`.
- Windows: run `powershell -ExecutionPolicy Bypass -File install.ps1`.

Open your applications menu or Start Menu, type "Kimi", and click "Kimi CLI".

## Customize (Linux)

The launcher uses `xfce4-terminal` and expects the CLI at `~/.kimi-code/bin/kimi`.
To change either, edit the `Exec=` line in `kimi-code.desktop` and run `./install.sh`
again. Terminal examples:

- GNOME Terminal: `gnome-terminal -- /home/USER/.kimi-code/bin/kimi`
- Konsole: `konsole -e /home/USER/.kimi-code/bin/kimi`

## Uninstall

- Linux: remove `~/.local/share/applications/kimi-code.desktop` and
  `~/.local/share/icons/kimi.png`, then run
  `update-desktop-database ~/.local/share/applications/`.
- Windows: remove `Kimi CLI.lnk` from the Start Menu Programs folder and the
  `%LOCALAPPDATA%\kimi-code-launcher\` folder.

## Files

- `install.sh` and `kimi-code.desktop` — the Linux installer and menu entry.
- `install.ps1` — the Windows installer. Copies the icon and creates the shortcut.
- `kimi.png` and `kimi.ico` — the Kimi "K" icon (48 by 48 pixels) for Linux and Windows.

## License

The icon belongs to Moonshot AI. The rest of this project is free to use.
