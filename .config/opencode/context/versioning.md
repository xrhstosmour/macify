# Versioning and GitHub Conventions

## Commit Format

Use conventional commits:

```text
feat(scope): short description
fix(scope): short description
refactor(scope): short description
test(scope): short description
docs(scope): short description
chore(scope): short description
```

## Branch Naming

```text
feature/<name>
fix/<name>
refactor/<name>
```

## Fixup Workflow

Use fixups for review changes on existing branch commits:

```bash
git commit --fixup <sha>
git rebase -i --autosquash origin/main
```

## GitHub Access

Use `gh` CLI for pull request workflows.

```bash
gh pr create --title "<title>" --body-file <file>
gh pr view --web
gh pr comment <number> --body "<comment>"
```

## PR Template

Rules:

- Do not leave placeholders in final PR bodies.
- Replace all template fields with concrete page paths, commands, data IDs, and expected results.
- If no issue or task link exists, omit the "Resolves" line.

```markdown
## What
One-line change summary.

## Why
Problem being solved.

Resolves [issue_task_id](link/to/issue_or_task).

## Testing
Reviewer validation flow:

### UI flow checks
1. Open `<environment_url_or_page>`.
2. Navigate to `<page_or_section>`.
3. Perform user action: `<click/type/select exact action>`.
4. Continue flow: `<example: add item to cart and proceed to checkout>`.
5. Confirm expected result: `<visible message/state/value>`.

### Data/CLI checks
1. Fetch/setup required data:
   - `<command to seed or fetch db entry>`
2. Execute changed behavior:
   - `<command or script that runs the new method>`
3. Verify output/state:
   - `<expected output, db change, or log line>`

### Regression checks
1. Run tests:
   - `<test command>`
2. Run lint/static checks:
   - `<lint or static check command>`
```
