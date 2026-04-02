# Models

## Routing

Default to FREE models. Switch to PREMIUM only when user approves.

## Selection

| Task | Premium | Free |
| --- | --- | --- |
| Planning/Analysis | `github-copilot/gpt-5` | `opencode/big-pickle` |
| Code/Implementation | `github-copilot/gpt-5.3-codex` | `opencode/minimax-m2.5-free` |
| Testing | `github-copilot/gpt-5.2-codex` | `opencode/gpt-5-nano` |
| Design/UX | `github-copilot/gpt-5-mini` | `opencode/big-pickle` |

To switch: `/model <model-name>`

## Escalation

If using premium and hitting complexity issues, escalate:

1. `opencode/big-pickle` → `opencode/minimax-m2.5-free` → `github-copilot/gpt-5.4` → `github-copilot/gpt-5.3-codex`
