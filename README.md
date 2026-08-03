# Kimi Code Launcher

Adds Kimi Code CLI to the applications menu on Linux and the Start Menu on Windows.
Made for Linux Mint and Windows 10/11.

## What it does

- It puts "Kimi CLI" in your applications menu or Start Menu.
- It opens a terminal when you click the menu entry.
- It starts Kimi Code CLI in that terminal.
- It shows the Kimi "K" icon in the menu.

## Requirements

- Linux or Windows. Linux Mint is the main Linux target. Mint 22.x is tested.
- On Linux: the `xfce4-terminal` program. Mint Xfce has it by default.
- On Windows: PowerShell. Windows Terminal is used if it is installed.
- Kimi Code CLI. The script can install it for you. See the next section.

## Install on Linux

Do these steps:

1. Clone this repository.
2. Go into the repository folder.
3. Run `./install.sh`.
4. Open your applications menu.
5. Type "Kimi" in the search field.
6. Click "Kimi CLI".

The script checks for Kimi Code CLI first. If the CLI is missing, the script tells you.
It then asks before it installs anything. Answer `y` to install, or `n` to skip.
The script downloads the CLI from the official Kimi site only:
`https://code.kimi.com/kimi-code/install.sh`. It uses no other source.

The script copies two files:

- `kimi.png` goes to `~/.local/share/icons/`.
- `kimi-code.desktop` goes to `~/.local/share/applications/`.

The script also puts your home path into the desktop file.

## Install on Windows

Do these steps:

1. Clone this repository.
2. Go into the repository folder.
3. Run `powershell -ExecutionPolicy Bypass -File install.ps1`.
4. Open the Start Menu.
5. Type "Kimi" in the search field.
6. Click "Kimi CLI".

The script checks for Kimi Code CLI first. If the CLI is missing, the script tells you.
It then asks before it installs anything. Answer `y` to install, or `n` to skip.
The script downloads the CLI from the official Kimi site only:
`https://code.kimi.com/kimi-code/install.ps1`. It uses no other source.

The script copies one file and makes one shortcut:

- `kimi.ico` goes to `%LOCALAPPDATA%\kimi-code-launcher\`.
- `Kimi CLI.lnk` goes to the Start Menu Programs folder.

The shortcut opens Windows Terminal. If Windows Terminal is missing, it uses `cmd.exe`.

## Use a different terminal (Linux)

The launcher uses `xfce4-terminal`. To change it, do these steps:

1. Open `kimi-code.desktop` in a text editor.
2. Find the `Exec=` line.
3. Replace it with your terminal. Examples:
   - GNOME Terminal: `gnome-terminal -- /home/USER/.kimi-code/bin/kimi`
   - Konsole: `konsole -e /home/USER/.kimi-code/bin/kimi`
4. Run `./install.sh` again.

## Use a different install path (Linux)

Kimi Code CLI must be at `~/.kimi-code/bin/kimi`. If it is not, do these steps:

1. Find the real path. Run `which kimi`.
2. Open `kimi-code.desktop` in a text editor.
3. Put the real path in the `Exec=` line.
4. Run `./install.sh` again.

## Uninstall on Linux

Do these steps:

1. Remove `~/.local/share/applications/kimi-code.desktop`.
2. Remove `~/.local/share/icons/kimi.png`.
3. Run `update-desktop-database ~/.local/share/applications/`.

## Uninstall on Windows

Do these steps:

1. Remove `Kimi CLI.lnk` from the Start Menu Programs folder.
2. Remove the `%LOCALAPPDATA%\kimi-code-launcher\` folder.

## Files

- `kimi-code.desktop` is the Linux menu entry.
- `kimi.png` is the Kimi "K" icon. It is 48 by 48 pixels.
- `kimi.ico` is the same icon for Windows.
- `install.sh` copies the files to the correct folders on Linux.
- `install.ps1` copies the files and makes the shortcut on Windows.

## License

The icon belongs to Moonshot AI. The rest of this project is free to use.
