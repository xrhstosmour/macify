# Add `Homebrew`'s binary directory to the `PATH` environment variable.
fish_add_path "/opt/homebrew/bin/"

# Disable `Homebrew` environment update hints.
set -gx HOMEBREW_NO_ENV_HINTS 1

# Use `1Password` as the `SSH` agent.
set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Enable `Starship` as `Fish` prompt.
starship init fish | source

# Enable `Zoxide` at `Fish` shell.
zoxide init fish | source

# Enable and configure `Atuin` at `Fish` shell.
set -gx ATUIN_NOBIND "true"
atuin init fish | source
bind \ch _atuin_search
bind -M insert \ch _atuin_search

# Disable welcome message.
set -U fish_greeting

# Activate `mise` environment for `Fish` shell.
mise activate fish | source

# Source needed `Fish` constants.
source $HOME/.config/fish/constants/colors.fish

# Source needed `Fish` functions.
source $HOME/.config/fish/functions/files.fish
source $HOME/.config/fish/functions/git.fish
source $HOME/.config/fish/functions/logs.fish
source $HOME/.config/fish/functions/emulators.fish
source $HOME/.config/fish/functions/keybindings.fish
source $HOME/.config/fish/functions/aliases.fish
