# Dotfiles

macOS system configuration via shell scripts.

## Features

- Developer Setup
  - Setup: `Xcode`, `Homebrew`, `Git`, `Fish`, `Starship`, `mise`
  - Languages: `.NET Core`, `Go`, `Java`, `Node.js`, `Python`, `Ruby`
- System configuration (`Finder`, Dock, Menu Bar, Display, Audio, Trackpad, `TouchID`)
- Keyboard remapping with persistence and cheat sheet
- Window/Tiling manager (`AeroSpace`)
- Appearance (themes, wallpapers, dark mode)
- Security (firewall, stealth mode, file-sharing whitelist)
- Cleanup (remove default macOS applications)

## Requirements

Due to `macOS` security restrictions, configure the following:

### Before Installation

- **Full Disk Access**: `System Settings` → `Privacy & Security` → `Full Disk Access`
  - Add Terminal application which will be used for running the installation script.
- **Accessibility**: `System Settings` → `Privacy & Security` → `Accessibility`
  - Add Terminal application which will be used for running the installation script.
- **Applications**: Edit [packages/Brewfile](packages/Brewfile)
  - Modify the list of `CLI` tools and `GUI` applications to match your preferences.

### After Installation

- **Reduce Motion**: `System Settings` → `Accessibility` → `Display` → `Reduce motion`
  - Enable it.
- **Full Disk Access**: `System Settings` → `Privacy & Security` → `Full Disk Access`
  - Add `WezTerm` application.
- **Developer Tools**: `System Settings` → `Privacy & Security` → `Developer Tools`
  - Add `WezTerm` application.
  - Add `Visual Studio Code` application.
- **Input Monitoring**: `System Settings` → `Privacy & Security` → `Input Monitoring`
  - Add `/usr/bin/hidutil` executable, for keyboard remapping scripts.
  - Add `/usr/bin/sudo` executable, for keyboard remapping scripts.
- **Accessibility**: `System Settings` → `Privacy & Security` → `Accessibility`
  - Add `AeroSpace` application.
  - Add `Maccy` application.
  - Add `SwipeAeroSpace` application.
  - Add `WezTerm` application.
- **GitHub CLI**:
  - Run `gh auth login` to authenticate.

## Installation

Execute with administrative privileges: `./install.sh`

The installer will prompt for approvals before making changes.

## Packages

**CLI Tools**

- `1password-cli`
- `aria2`
- `atuin`
- `bat`
- `bottom`
- `displayplacer`
- `eva`
- `eza`
- `fastfetch`
- `fd`
- `fdupes`
- `ffmpeg`
- `fish`
- `fisher`
- `fzf`
- `gh`
- `goto-ssh`
- `helix`
- `jless`
- `kdiff3`
- `mas`
- `mise`
- `mole`
- `scrcpy`
- `sd`
- `starship`
- `superfile`
- `telnet`
- `tig`
- `witr`
- `xh`
- `zoxide`

**GUI Apps**

- `1password`
- `android-platform-tools`
- `aerospace`
- `brave-browser`
- `docker`
- `filen`
- `flameshot`
- `font-fira-code`
- `google-chrome`
- `google-drive`
- `localsend`
- `maccy`
- `macfuse`
- `nordvpn`
- `obsidian`
- `postman`
- `signal`
- `spotify`
- `sublime-text`
- `syncthing`
- `utm`
- `veracrypt`
- `viber`
- `visual-studio-code`
- `wailbrew`
- `wezterm`
- `whatsapp`

**App Store**: `Perplexity AI`, `Amphetamine`
