#!/bin/bash
# Catch exit signal (`CTRL` + `C`) to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
KEYBOARD_SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import constant variables.
source "$KEYBOARD_SCRIPT_DIRECTORY/../helpers/logs.sh"

# Function to apply Keyboard configuration.
#
# More details:
#   - https://hidutil-generator.netlify.app/
#   - https://apple.stackexchange.com/questions/467341/hidutil-stopped-working-on-macos-14-2-update
#
# Usage:
#   apply_keyboard_configuration
apply_keyboard_configuration() {
    log_info "Applying Keyboard configuration..."

    # Enable full keyboard access for all controls.
    log_info "Enabling full keyboard access for all controls..."
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Disable `Smart Quotes` when typing code.
    log_info "Disabling 'Smart Quotes' when typing code..."
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable `Smart Dashes` when typing code.
    log_info "Disabling 'Smart Dashes' when typing code..."
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable auto-correct.
    log_info "Disabling auto-correct..."
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable `Emoji` picker.
    log_info "Disabling 'Emoji' picker..."
    defaults write com.apple.HIToolbox AppleFnUsageType -int 0

    # Disable press & hold for accents.
    log_info "Disabling press & hold for accents..."
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Clear existing `hidutil` mappings and apply new ones.
    keyboard_clear_hidutil_mappings
    keyboard_apply_special_key_mappings

    log_success "Keyboard configuration applied successfully."
    log_divider
}

# Function to clear existing hidutil mappings and launch agent.
# Usage:
#   keyboard_clear_hidutil_mappings
keyboard_clear_hidutil_mappings() {
    log_info "Clearing existing 'hidutil' mappings..."

    # Clear `hidutil` mappings.
    /usr/bin/hidutil property --set '{"UserKeyMapping":[]}' >/dev/null 2>&1

    # Remove any existing launch agent.
    if [ -f ~/Library/LaunchAgents/com.local.KeyRemapping.plist ]; then
        log_info "Removing existing launch agent..."
        launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2>/dev/null || true
        rm -f ~/Library/LaunchAgents/com.local.KeyRemapping.plist
    fi

    log_success "'hidutil' mappings cleared."
}

# Function to configure password-less `sudo` for `hidutil`.
# Required for `LaunchAgent` to run `hidutil` without password prompt.
# Usage:
#   configure_password_less_sudo
configure_password_less_sudo() {
    log_info "Configuring password-less 'sudo' for 'hidutil'..."

    # Check if already configured.
    if sudo grep -q "^$USER ALL=(ALL) NOPASSWD: /usr/bin/hidutil$" /etc/sudoers.d/hidutil-mapping 2>/dev/null; then
        log_info "Password-less 'sudo' for 'hidutil' already configured."
        return
    fi

    echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/hidutil" | sudo tee /etc/sudoers.d/hidutil-mapping >/dev/null
    sudo chmod 440 /etc/sudoers.d/hidutil-mapping
    log_success "Password-less 'sudo' configured for 'hidutil'."
}

# Function to apply special key mappings via `hidutil`.
# Maps Section Sign → Tilde and Right Shift → Delete.
# These mappings cannot be configured via System Settings.
# Usage:
#   keyboard_apply_special_key_mappings
keyboard_apply_special_key_mappings() {
    log_info "Applying Section Sign → Tilde and Right Shift → Delete mappings..."

    # Configure password-less `sudo`, required for `LaunchAgent`.
    configure_password_less_sudo

    # Apply mappings immediately for this session.
    sudo /usr/bin/hidutil property --set '{"UserKeyMapping":[
        {
          "HIDKeyboardModifierMappingSrc": 0x700000064,
          "HIDKeyboardModifierMappingDst": 0x700000035
        },
        {
          "HIDKeyboardModifierMappingSrc": 0x7000000E5,
          "HIDKeyboardModifierMappingDst": 0x70000004C
        }
    ]}' >/dev/null 2>&1

    # Create launch agent for persistence.
    keyboard_create_launch_agent

    log_success "Special key mappings applied (Section Sign → Tilde, Right Shift → Delete)."
}

# Function to create launch agent for `hidutil` persistence.
# Creates a launch agent that will reapply `hidutil` mappings on system startup.
# Usage:
#   keyboard_create_launch_agent
keyboard_create_launch_agent() {
    log_info "Creating launch agent for 'hidutil' persistence..."

    # Create launch agent directory if it doesn't exist.
    mkdir -p ~/Library/LaunchAgents

    # Create the launch agent plist with the correct `hidutil` mappings.
    cat >~/Library/LaunchAgents/com.local.KeyRemapping.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/sudo</string>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[
            {
              "HIDKeyboardModifierMappingSrc": 0x700000064,
              "HIDKeyboardModifierMappingDst": 0x700000035
            },
            {
              "HIDKeyboardModifierMappingSrc": 0x7000000E5,
              "HIDKeyboardModifierMappingDst": 0x70000004C
            }
        ]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

    # Load the launch agent.
    launchctl load -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2>/dev/null || true

    log_success "Launch agent created and loaded for 'hidutil' persistence."
}
