# Kimi CLI Launcher

Adds Kimi CLI to the applications menu on Linux and the Start Menu on Windows.
Made for Linux Mint and Windows 10/11.

## What it does

- Puts "Kimi CLI" in your applications menu or Start Menu, with the Kimi "K" icon.
- Opens a terminal and starts Kimi Code CLI when you click it.
- On every launch:
  1. Checks `https://code.kimi.com/kimi-code/latest.json` (falling back to
     `/latest`) and updates the CLI via the official installer when a newer
     version exists (silent when up to date; skips the check if the network
     is down).
  2. Asks which mode to use (skipped when a mode was passed):
     - **Auto + K3 Max (1M)** — auto permission mode (`--auto`), K3 model with
       1M context (`-m kimi-code/k3`), max thinking effort
       (`KIMI_MODEL_THINKING_EFFORT=max`)
     - **Auto** — auto permission mode (`--auto`)
     - **Yolo (skip approvals)** — `--yolo`
     - **Plan mode** — `--plan`
     - **Manual** — plain launch
  3. Asks whether to start a **New chat** or **Browse previous chats** (the
     latter opens the session picker, `kimi --session`).
- Windows only: adds a "Kimi CLI" right-click submenu for folders in Explorer.
  Right-click inside a folder (or on a folder) and pick a mode directly — the
  same five modes as above, pre-selected so only the chat prompt is shown.
  On Windows 11 the submenu lives in the classic context menu: right-click and
  choose "Show more options" (or press Shift+F10) to see it.
- Linux only: adds a "Kimi CLI" right-click submenu in Thunar. Right-click a
  folder (or empty space inside one) and pick a mode directly — the same five
  modes as above, pre-selected so only the chat prompt is shown.

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
To change the terminal, edit the `Exec=` line in `kimi-code.desktop` and run
`./install.sh` again. Terminal examples:

- GNOME Terminal: `gnome-terminal -- /home/USER/.local/share/kimi-cli-launcher/kimi-launch.sh`
- Konsole: `konsole -e /home/USER/.local/share/kimi-cli-launcher/kimi-launch.sh`

To skip the mode menu, pass a mode to the launcher:
`kimi-launch.sh auto` (or `auto-max`, `yolo`, `plan`, `manual`).

## Uninstall

- Linux: remove `~/.local/share/applications/kimi-code.desktop`,
  `~/.local/share/icons/kimi.png`, and `~/.local/share/kimi-cli-launcher/`,
  then run `update-desktop-database ~/.local/share/applications/`.
  To remove the right-click menu, open `~/.config/Thunar/uca.xml` and delete
  the block between `<!-- KIMI-CLI-START -->` and `<!-- KIMI-CLI-END -->`.
- Windows: remove `Kimi CLI.lnk` from the Start Menu Programs folder and the
  `%LOCALAPPDATA%\kimi-code-launcher\` folder.
  To remove the right-click menu, delete these two registry keys (e.g. in Registry
  Editor or with `reg delete`):
  - `HKCU\Software\Classes\Directory\Background\shell\KimiCLI`
  - `HKCU\Software\Classes\Directory\shell\KimiCLI`

## Files

- `install.sh` and `kimi-code.desktop` — the Linux installer and menu entry.
- `kimi-uca.xml` — the Thunar right-click actions. The installer merges them
  into `~/.config/Thunar/uca.xml` and leaves other entries alone.
- `kimi-launch.sh` — Linux mode launcher; checks for updates, shows the mode
  menu (unless a mode was passed), asks new vs. previous chat, and starts the CLI.
- `update-kimi.sh` — Linux updater; compares the installed CLI version against
  `https://code.kimi.com/kimi-code/latest` and runs the official installer when
  they differ.
- `install.ps1` — the Windows installer. Copies the icon, the mode launcher, and
  the updater; creates the shortcuts; registers the Explorer right-click menu.
- `kimi-launch.cmd` — Windows mode launcher; checks for updates, shows the mode
  menu (unless a mode was passed), asks new vs. previous chat, and opens Windows
  Terminal (or `cmd.exe`) in the chosen folder.
- `update-kimi.ps1` — the Windows updater. Same logic as `update-kimi.sh`.
- `kimi.png` and `kimi.ico` — the Kimi "K" icon (48 by 48 pixels) for Linux and Windows.

## License

The icon belongs to Moonshot AI. The rest of this project is free to use.
