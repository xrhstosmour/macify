# Function to list and interact with opencode sessions using fzf.
# Pressing:
#   - ENTER will resume the selected session
#   - DELETE will delete the session
#   - ? will toggle the preview
# Usage:
#   opencode_session_list
function __opencode_session_preview
    set -l sid "$argv[1]"

    opencode export "$sid" 2>/dev/null | python3 -c '
import datetime
import re
import sys

raw = sys.stdin.read()

def find(text, pattern):
    m = re.search(pattern, text, re.S)
    return m.group(1) if m else "-"

info_match = re.search(r"\"info\"\s*:\s*\{(.*?)\}\s*,\s*\"messages\"", raw, re.S)
info = info_match.group(1) if info_match else raw

sid = find(info, r"\"id\"\s*:\s*\"([^\"]+)\"")
project_id = find(info, r"\"projectID\"\s*:\s*\"([^\"]+)\"")
directory = find(info, r"\"directory\"\s*:\s*\"([^\"]+)\"")
title = find(info, r"\"title\"\s*:\s*\"([^\"]+)\"")
created_ms = find(info, r"\"created\"\s*:\s*(\d+)")
updated_ms = find(info, r"\"updated\"\s*:\s*(\d+)")

provider_id = find(raw, r"\"providerID\"\s*:\s*\"([^\"]+)\"")
model_id = find(raw, r"\"modelID\"\s*:\s*\"([^\"]+)\"")

description = find(raw, r"\"role\"\s*:\s*\"user\".*?\"text\"\s*:\s*\"((?:\\.|[^\"])*)\"")
if description != "-":
    description = bytes(description, "utf-8").decode("unicode_escape", "ignore")

def fmt(ms):
    if not ms.isdigit():
        return "-"
    ts = int(ms) / 1000.0
    return datetime.datetime.fromtimestamp(ts).astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")

model = "-"
if provider_id != "-" and model_id != "-":
    model = f"{provider_id}/{model_id}"
elif provider_id != "-":
    model = provider_id

print(f"\033[1;33mID:\033[0m {sid}")
print(f"\033[1;33mDirectory:\033[0m {directory}")
print(f"\033[1;33mCreatedAt:\033[0m {fmt(created_ms)}")
print(f"\033[1;33mUpdatedAt:\033[0m {fmt(updated_ms)}\n")
print(f"\033[1;34mTitle:\033[0m {title}")
print(f"\033[1;34mModel:\033[0m {model}\n")
print(f"\033[1;32mDescription:\033[0m {description}")
'
end

function opencode_session_list
    set -l lines (opencode session list | string split '\n')
    if test (count $lines) -lt 3
        log_error "No sessions found!"
        return 1
    end

    set -l selected_sid (for line in $lines[3..-1]
        set -l sid (string match -r '^ses_[^[:space:]]+' -- "$line")
        if test -z "$sid"
            continue
        end

        set -l title_with_updated (string replace -r '^ses_[^[:space:]]+\s+' '' -- "$line")
        set -l title (string replace -r '\s+[0-9]{1,2}:[0-9]{2}\s+[AP]M(\s+·\s+[0-9]{1,2}/[0-9]{1,2}/[0-9]{4})?$' '' -- "$title_with_updated")

        printf '%s\t\033[1;33m%s\033[0m \033[1;32m|\033[0m %s\n' "$sid" "$sid" "$title"
    end | fzf --ansi --height=20 --delimiter='\t' --with-nth=2.. --bind 'enter:accept,delete:execute(opencode session delete {1})+abort,?:toggle-preview' --preview '
        __opencode_session_preview {1}
    ' --preview-window=right:50%:hidden:wrap | cut -f1)

    if test -n "$selected_sid"
        opencode -s "$selected_sid"
    end

    return 0
end
