#!/bin/bash

# Catch exit signal (`CTRL` + `C`) to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
DEVELOPER_SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import functions and flags.
source "$DEVELOPER_SCRIPT_DIRECTORY/../helpers/logs.sh"

# Copy `Git` configuration file and configure credentials.
if [ ! -f ~/.gitconfig ]; then
  log_info "Copying 'Git' configuration..."
  cp "$DEVELOPER_SCRIPT_DIRECTORY/../.gitconfig" ~

  log_info "Configuring 'Git'..."
  read -p "Enter your 'Git' name: " git_name
  read -p "Enter your 'Git' email: " git_email

  {
    echo "[user]"
    echo "	name = $git_name"
    echo "	email = $git_email"
  } | cat - ~/.gitconfig > ~/.gitconfig.tmp && mv ~/.gitconfig.tmp ~/.gitconfig
else
  log_info "'Git' is already configured."
fi
log_divider

# Configure `1Password SSH` agent if `1password` and `1password-cli` are in `Brewfile`.
BREWFILE_PATH="$DEVELOPER_SCRIPT_DIRECTORY/../packages/Brewfile"
if grep -q "cask '1password'" "$BREWFILE_PATH" && grep -q "cask '1password-cli'" "$BREWFILE_PATH"; then
  FISH_CONFIG="$HOME/.config/fish/config.fish"
  SSH_AUTH_LINE="set -gx SSH_AUTH_SOCK ~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  if ! grep -q "2BUA8C4S2C.com.1password" "$FISH_CONFIG" 2>/dev/null; then
    log_info "Configuring '1Password' SSH agent in 'Fish' config..."

    # Insert after `HOMEBREW_NO_ENV_HINTS` line.
    sed -i '' '/HOMEBREW_NO_ENV_HINTS/a\
\
# Use `1Password` as the `SSH` agent.\
'"$SSH_AUTH_LINE"'' "$FISH_CONFIG"
    log_success "'1Password' SSH agent configured."
  else
    log_warning "'1Password' SSH agent already configured in 'Fish' config."
  fi
fi
log_divider

# Create `Developer` directory.
if [ ! -d ~/Developer ]; then
  log_info "Creating 'Developer' directory..."
  mkdir ~/Developer
else
  log_warning "'Developer' directory already exists."
fi
