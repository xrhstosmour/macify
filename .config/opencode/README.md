# OpenCode Configuration

Minimal specialist setup for pragmatic software development.

## Architecture

```text
~/.config/opencode/           # BASE CONFIG
├── opencode.json             # Main configuration
├── INSTRUCTIONS.md           # Startup instructions
├── context/                  # Base context (loaded always)
│   ├── communication.md
│   ├── github.md
│   ├── knowledge.md
│   ├── preferences.md
│   ├── rules.md
│   └── versioning.md
├── commands/                 # Workflow commands
├── agent/                    # Agent definitions
└── skills/                   # Reusable skills
```

## Workflow

| Phase | Command | Agent | Purpose |
| ----- | ------ | ----- | ------- |
| Plan | `/plan` | `leader` | Assess scope, present approach, iterate until approved |
| Code | `/code` | `implementor` | Implement approved scope, show changes, iterate until approved |
| Test | `/test` | `tester` | Run tests and quality checks |
| Review | `/review` | `reviewer` | Code review for quality, security, best practices |

## Commands

| Command | Agent | Purpose |
| ------ | ----- | ------- |
| `/plan` | `leader` | Plan and scope task |
| `/code` | `implementor` | Implement changes |
| `/test` | `tester` | Run tests and checks |
| `/review` | `reviewer` | Review code quality |
| `/resolve` | - | Resolve `PR` review comments |

## Context Files

| File | Purpose |
| ---- | ------- |
| `communication.md` | Communication style guidelines |
| `knowledge.md` | Tools and knowledge base info |
| `preferences.md` | Writing and formatting preferences |
| `rules.md` | Core implementation rules, safety, error handling, debugging |
| `versioning.md` | `Git` conventions and commit rules |
| `github.md` | `GitHub CLI` commands and `PR` guidelines |

## Skills

Skills are loaded by agents and triggered via commands.

| Skill | Command | Purpose |
| ----- | ------ | ------- |
| `resolve_pr_comments` | `/resolve` | Review `PR` comments, assess validity, plan fixes, make fixup commits, push, reply with `SHA` links |

## Agents

| Agent | Model | Purpose |
| ----- | ----- | ------- |
| `leader` | `claude-sonnet-4-5` | Orchestration, delegates only when needed |
| `clarifier` | `claude-haiku-4-5` | Requirements clarification |
| `architect` | `claude-sonnet-4-5` | Architecture decisions |
| `designer` | `claude-haiku-4-5` | `UI`/`UX` design (frontend only) |
| `implementor` | `claude-sonnet-4-5` | Bounded implementation |
| `tester` | `claude-haiku-4-5` | Tests and quality checks |
| `reviewer` | `claude-haiku-4-5` | Code review |
