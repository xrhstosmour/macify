---
description: Implement approved scope
agent: implementor
---

# Code

Implement approved scope. Show changes and iterate based on feedback until user approves.

## Entry Criteria

- `/plan` phase is complete.
- User has approved the plan.

## Exit Criteria

- All planned changes are implemented.
- User approves the changes.
- Lint/typecheck passes on changed files.

## Phase Transition

After approval → proceed to `/test`.
If scope creep is identified → return to `/plan`.
If tests fail → fix and re-test.
