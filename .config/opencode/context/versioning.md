# Versioning

## Commits

Conventional commits, without agent co-authors.
Wrap in backticks:

- technical identifiers
- code elements
- file names and paths

while leaving unformatted:

- natural language words
- headings
- `YAML` frontmatter fields

```text
feat: Add `Sentry` integration
fix: Fix `APIEndpoint` timeout
refactor: Rename `utils` file to `utilities`
test: Add tests for `User` model
docs: Update `README.md` with setup instructions
```

- fixup: for review comment fixes, typos, small oversights
- amend: for single commit changes
- Split by context. Include tests in same commit as code.

```bash
git add <file> && git commit --fixup <SHA>
git rebase -i --autosquash master
git commit --amend --no-edit
```

### Git safety

- Never force-push to `main` or `master`
- Never commit `.env`, secrets, credentials. Warn immediately if staged.

### Fixups

Target only original commits. NEVER fixup a fixup.

Rules:

- Target must be in `<base>..HEAD`
- One target per fixup. Never mix hunks from different `SHA`s
- Use `git add -p` to split hunks
- Uncertain mapping: stop and clarify
- New work (no valid target): use regular commit
- Push with `--force-with-lease`

Wrong: `git commit --fixup <fixup_sha>`
Right: `git commit --fixup <original_sha>`

To fix a fixup: find original, fixup that directly, or `git rebase -i` to squash.

```bash
# Original.
abc123 feat: Add feature X
# Fixup (correct).
def456 fixup! feat: Add feature X
# Another fix -> fixup ORIGINAL, NOT def456.
git commit --fixup abc123
```

## Save-Point Pattern

Commit locally each tested increment per the increment cycle in rules.md. Commits are save points, if the next change breaks something, revert to the last known-good state.

## Commit Size

Target ~100 lines per commit. Split commits over ~300 lines.

## Change Summaries

After any modification, provide a structured summary:

``` text
CHANGES MADE:
- src/path/to/file: What was changed and why

THINGS I DIDN'T TOUCH (intentionally):
- src/other/file: Has a similar issue but out of scope

POTENTIAL CONCERNS:
- Any risks, trade-offs, or open questions
```

## Worktrees

For parallel agent work on multiple features:

```bash
git worktree add ../project-feature-a feature/task-creation
git worktree add ../project-feature-b feature/user-settings

# When done, merge and clean up.
git worktree remove ../project-feature-a
```

Each worktree is a separate directory with its own branch. Agents work in parallel without interfering.

## Branch

`feature/<name>` / `fix/<name>` / `refactor/<name>`
