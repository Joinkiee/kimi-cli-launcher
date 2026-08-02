# Kimi Code Launcher

Adds Kimi Code CLI to the applications menu on Linux. Made for Linux Mint.

## What it does

- It puts "Kimi Code" in your applications menu.
- It opens a terminal when you click the menu entry.
- It starts Kimi Code CLI in that terminal.
- It shows the Kimi "K" icon in the menu.

## Requirements

- Linux. Linux Mint is the main target. Mint 22.x is tested.
- The `xfce4-terminal` program. Mint Xfce has it by default.
- Kimi Code CLI. The script can install it for you. See the next section.

## Install

Do these steps:

1. Clone this repository.
2. Go into the repository folder.
3. Run `./install.sh`.
4. Open your applications menu.
5. Type "Kimi" in the search field.
6. Click "Kimi Code".

The script checks for Kimi Code CLI first. If the CLI is missing, the script tells you.
It then asks before it installs anything. Answer `y` to install, or `n` to skip.
The script downloads the CLI from the official Kimi site only:
`https://code.kimi.com/kimi-code/install.sh`. It uses no other source.

The script copies two files:

- `kimi.png` goes to `~/.local/share/icons/`.
- `kimi-code.desktop` goes to `~/.local/share/applications/`.

The script also puts your home path into the desktop file.

## Use a different terminal

The launcher uses `xfce4-terminal`. To change it, do these steps:

1. Open `kimi-code.desktop` in a text editor.
2. Find the `Exec=` line.
3. Replace it with your terminal. Examples:
   - GNOME Terminal: `gnome-terminal -- /home/USER/.kimi-code/bin/kimi`
   - Konsole: `konsole -e /home/USER/.kimi-code/bin/kimi`
4. Run `./install.sh` again.

## Use a different install path

Kimi Code CLI must be at `~/.kimi-code/bin/kimi`. If it is not, do these steps:

1. Find the real path. Run `which kimi`.
2. Open `kimi-code.desktop` in a text editor.
3. Put the real path in the `Exec=` line.
4. Run `./install.sh` again.

## Uninstall

Do these steps:

1. Remove `~/.local/share/applications/kimi-code.desktop`.
2. Remove `~/.local/share/icons/kimi.png`.
3. Run `update-desktop-database ~/.local/share/applications/`.

## Files

- `kimi-code.desktop` is the menu entry.
- `kimi.png` is the Kimi "K" icon. It is 48 by 48 pixels.
- `install.sh` copies the files to the correct folders.

## License

The icon belongs to Moonshot AI. The rest of this project is free to use.
