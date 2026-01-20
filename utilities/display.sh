#!/bin/bash
# Catch exit signal (`CTRL` + `C`) to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
DISPLAY_SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import constant variables.
source "$DISPLAY_SCRIPT_DIRECTORY/../helpers/logs.sh"

# Function to apply Display configuration.
# Usage:
#   apply_display_configuration
apply_display_configuration() {
    log_info "Applying Display configuration..."

    # Change display resolution to hide the notch.
    display_id=$(displayplacer list | grep -B 3 "Type: MacBook built in screen" | head -1 | sed 's/Persistent screen id: //')
    if [ -z "$display_id" ]; then
        log_warning "Built-in display not detected or disabled."
    else
        # Get all modes for this display.
        display_modes=$(displayplacer list | grep "$display_id" -A 100)

        # Get current resolution.
        current_resolution=$(echo "$display_modes" | grep "<-- current mode" | awk '{print $3}' | cut -d':' -f2)

        # Find the highest available refresh rate for scaled modes.
        max_hz=$(echo "$display_modes" | grep -E "^\s+mode [0-9]+:" | grep "scaling:on" | grep -o "hz:[0-9]*" | cut -d':' -f2 | sort -rn | head -1)

        # Find the default `macOS` mode, highest refresh rate with notch-showing resolution.
        # The notch-showing resolution has a taller height.
        # Filter to only "mode X:" lines with scaling:on and max refresh rate, excluding current mode marker.
        default_notch_mode=$(echo "$display_modes" | grep -E "^\s+mode [0-9]+:" | grep "hz:$max_hz" | grep "scaling:on" | grep -v "<-- current mode" | tail -1)
        default_notch_resolution=$(echo "$default_notch_mode" | awk '{print $3}' | cut -d':' -f2)

        # Check if current resolution is the notch-showing default.
        if [ "$current_resolution" != "$default_notch_resolution" ]; then
            log_info "Display resolution already customized ($current_resolution), skipping..."
        else
            # Find the notch-hiding mode, same width, shorter height, maximum refresh rate.
            current_width=$(echo "$default_notch_resolution" | cut -d'x' -f1)
            notch_hidden_mode=$(echo "$display_modes" | grep -E "^\s+mode [0-9]+:" | grep "hz:$max_hz" | grep "scaling:on" | grep "res:${current_width}x" | head -1)
            notch_hidden_resolution=$(echo "$notch_hidden_mode" | awk '{print $3}' | cut -d':' -f2)
            notch_hidden_hz=$(echo "$notch_hidden_mode" | awk '{print $4}' | cut -d':' -f2)
            notch_hidden_color_depth=$(echo "$notch_hidden_mode" | awk '{print $5}' | cut -d':' -f2)

            log_info "Hiding 'Notch' via changing display resolution from $default_notch_resolution to $notch_hidden_resolution..."
            displayplacer "id:$display_id res:$notch_hidden_resolution hz:$notch_hidden_hz color_depth:$notch_hidden_color_depth scaling:on origin:(0,0) degree:0"
        fi
    fi

    log_success "Display configuration applied successfully."
    log_divider
}
