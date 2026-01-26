#!/bin/bash
# Catch exit signal (`CTRL` + `C`) to terminate the whole script.
trap "exit" INT

# Terminate script on error.
set -e

# Constant variable of the scripts' working directory to use for relative paths.
DISPLAY_SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Import constant variables.
source "$DISPLAY_SCRIPT_DIRECTORY/../helpers/logs.sh"

# Function to get the preferred notch-hidden resolution for a screen.
# Usage:
#   get_preferred_resolution <native_resolution>
get_preferred_resolution() {
    case "$1" in
        "3024x1964") echo "1800x1125" ;;  # MacBook Pro 14"
        "3456x2234") echo "2056x1285" ;;  # MacBook Pro 16"
        "2560x1664") echo "1470x918" ;;   # MacBook Air 13"
        "2880x1864") echo "1710x1067" ;;  # MacBook Air 15"
        *) echo "" ;;
    esac
}

# Function to apply Display configuration.
# Usage:
#   apply_display_configuration
apply_display_configuration() {
    log_info "Applying Display configuration..."

    # Get built-in display info.
    local display_info=$(displayplacer list | grep -B 3 -A 200 "Type: MacBook built in screen")
    local display_id=$(echo "$display_info" | head -1 | sed 's/Persistent screen id: //')

    if [ -z "$display_id" ]; then
        log_warning "Built-in display not detected or disabled."
        log_divider
        return
    fi

    # Get current and native resolutions.
    local current_res=$(echo "$display_info" | grep "<-- current mode" | grep -o "res:[^ ]*" | cut -d':' -f2)
    local max_hz=$(echo "$display_info" | grep -E "^\s+mode [0-9]+:" | grep "scaling:on" | grep -o "hz:[0-9]*" | cut -d':' -f2 | sort -rn | head -1)
    # Native resolution is the highest one, last mode without scaling:on flag, or with the largest dimensions.
    local native_res=$(echo "$display_info" | grep -E "^\s+mode [0-9]+:" | grep -v "scaling:on" | tail -1 | grep -o "res:[^ ]*" | cut -d':' -f2)

    # Get preferred resolution for this screen size.
    local preferred_res=$(get_preferred_resolution "$native_res")

    if [ -z "$preferred_res" ]; then
        log_warning "No 'notch' hiding configuration for this screen."
    elif [ "$current_res" == "$preferred_res" ]; then
        log_warning "Notch already hidden."
    else
        log_info "Hiding 'notch'..."
        displayplacer "id:$display_id res:$preferred_res hz:$max_hz color_depth:8 scaling:on origin:(0,0) degree:0"
    fi

    log_success "Display configuration applied successfully."
    log_divider
}
