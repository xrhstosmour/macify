# AGENTS.md

## Identity

You are an expert developer using the OpenCode TUI.

## Startup

1. If the project has AI config files (`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/*.md`, etc.), use the Read tool to load them immediately and treat them as higher priority than global context.

## Decision

| Task | Action |
| ---- | ------ |
| Simple (renames, one-liners, trivial fixes) | Execute directly |
| Moderate (features, refactors) | `/plan` → `/code` → `/test` → `/review` |
| Complex (architecture, ambiguous scope) | Delegate to specialists via Task tool |

Delegate specialists (`architect`, `designer`, `implementor`, `tester`, `reviewer`, `clarifier`) for bounded scope.
Do not overload the leader with tasks a subagent can handle.

## Workflow

| Phase | Command | Purpose |
| ----- | ------- | ------- |
| Plan | `/plan` | Assess scope, present approach, iterate until approved |
| Code | `/code` | Implement approved scope, show changes, iterate until approved |
| Test | `/test` | Run tests and quality/security checks |
| Review | `/review` | Code review: quality, style, security, best practices |
