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

### Before Installation

- **Reduce Motion**: `System Settings` → `Accessibility` → `Display` → `Reduce motion`
  - Enable it.
- **Keyboard Modifier Keys**: `System Settings` → `Keyboard` → `Keyboard Shortcuts` → `Modifier Keys`
  - For Apple internal or external keyboards, select **Apple Internal Keyboard/Trackpad** or **Bluetooth keyboard** from the dropdown and configure:
    - Globe → Command
    - Control → Option
    - Option → Control
  - For non-Apple keyboards, select **Bluetooth keyboard** from the dropdown and configure:
    - Control → Command
    - Command → Option
    - Option → Control
  - Non-`Apple` external keyboards should **not** be set to macOS mode, use `Windows`/`PC` mode instead.
- **Spotlight**: `System Settings` → `Keyboard` → `Keyboard Shortcuts` → `Spotlight`
  - Enable only `Show Spotlight search` and set it to internal Control/external Super + `.`.
- **Input Sources**: `System Settings` → `Keyboard` → `Keyboard Shortcuts` → `Input Sources`
  - Enable only `Select the previous input source` and set it to internal Control/external Super + space.
- **Full Disk Access**: `System Settings` → `Privacy & Security` → `Full Disk Access`
  - Add Terminal application which will be used for running the installation script.
- **Accessibility**: `System Settings` → `Privacy & Security` → `Accessibility`
  - Add Terminal application which will be used for running the installation script.
- **Applications**: Edit [packages/Brewfile](packages/Brewfile)
  - Modify the list of `CLI` tools and `GUI` applications to match your preferences.
- **Abbreviations**: Edit [.config/fish/conf.d/abbr.fish](.config/fish/conf.d/abbr.fish)
  - Modify or add `Fish` shell abbreviations as desired.

### After Installation

- **Full Disk Access**: `System Settings` → `Privacy & Security` → `Full Disk Access`
  - Add `WezTerm` application.
- **Developer Tools**: `System Settings` → `Privacy & Security` → `Developer Tools`
  - Add `WezTerm` application.
  - Add `Visual Studio Code` application.
- **Accessibility**: `System Settings` → `Privacy & Security` → `Accessibility`
  - Add `AeroSpace` application.
  - Add `Maccy` application.
  - Add `SwipeAeroSpace` application.
  - Add `WezTerm` application.
- **GitHub CLI**:
  - Run `gh auth login` to authenticate.
- **OpenCode CLI**:
  - Run `opencode`, then type `/connect` and choose your provider.

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
- `opencode`
- `scrcpy`
- `sd`
- `starship`
- `superfile`
- `telnet`
- `tig`
- `tmux`
- `witr`
- `xh`
- `zoxide`

**GUI Apps**

- `1password`
- `adobe-acrobat-reader`
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
