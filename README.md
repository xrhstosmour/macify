# Dotfiles

This repository configures `macOS` system settings via seamless shell scripts.

## Changes

- **Developer Setup**: `Xcode` Command Line Tools, `Homebrew`, `Fish` shell.
- **System Configuration**: `Finder`, Dock, Menu Bar, Display, Audio, Trackpad.
- **Keyboard Management**: Key remapping with `LaunchAgent` persistence.
- **Window Manager**: `AeroSpace` with dual keyboard support (internal/external).
- **Appearance**: Themes, wallpapers, dark mode.
- **Security**: Firewall, stealth mode, file-sharing whitelist.
- **Cleanup**: Remove default `macOS` applications.

## Setup

Execute with administrative privileges: `./install.sh`

## Permissions Required

- **Input Monitoring**: `System Settings` → `Privacy & Security` → `Input Monitoring`.
  - `/usr/bin/hidutil`, `/usr/bin/sudo`.
- **Accessibility**: `System Settings` → `Privacy & Security` → `Accessibility`.
  - Required for `AeroSpace` and Spotlight functionality.
- **Full Disk Access**: `System Settings` → `Privacy & Security` → `Full Disk Access`.
  - Required for system cleanup and file modifications.
