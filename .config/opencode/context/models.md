# Model Routing

Use model by task complexity:

| Complexity | Model |
| --- | --- |
| Simple (Q&A, renames) | `opencode/big-pickle` |
| Lightweight (clarifications) | `github-copilot/claude-haiku-4.5` |
| Hard (architecture, complex code) | `github-copilot/gpt-5.3-codex` |

**Rule:** Start cheap, escalate only when complexity/risk justifies it.
