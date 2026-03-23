# OpenCode Config

Minimal specialist setup.

Flow: `/plan -> /code -> /test`

## Agent Architecture

Primary:

- `agent/leader.md`

Specialists:

- `agent/clarifier.md`
- `agent/architect.md`
- `agent/designer.md`
- `agent/implementor.md`
- `agent/tester.md`

## Command Routing

- `/plan` -> `leader`
- `/code` -> `implementor`
- `/test` -> `tester`

## Context Files

- `context/communication.md`
- `context/models.md`
- `context/versioning.md`

## Definition of Done

- Scope confirmed.
- Tests pass.
- Reviewer testing steps are concrete and executable.
- No obvious security or performance regressions.
- Follow-ups and risks are documented.

## Start

```bash
/plan "Add password reset"
```
