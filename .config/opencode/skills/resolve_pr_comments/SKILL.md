---
name: resolve_pr_comments
description: Review PR review comments, assess validity, plan fixes with user, make fixup commits, push, reply with SHA links and re-request reviews.
---

# Resolve PR Comments

## When to use this skill

Invoke this skill when the user says things like:

- "resolve pr comments"
- "fix pr comments"
- "/resolve <pr_url>"
- "/resolve (current branch's `PR` if exists)"

## Workflow

Follow these steps in order.

### Step 1 — Fetch comments

First, try to get the `PR` details from the current branch:
```bash
gh pr view --json number,headRepository,url
```

If there is an open `PR` for the current branch, extract owner, repo, and `PR` number from the response.
If no `PR` is found or user provides a `PR` URL, parse it to extract owner, repo, and `PR` number.
Fetch review threads with resolved state using `gh` via `GraphQL`:
```bash
gh api graphql -f query='\
query($owner:String!, $repo:String!, $number:Int!){\
  repository(owner:$owner,name:$repo){\
    pullRequest(number:$number){\
      reviewThreads(first:100){\
        nodes{\
          id\
          isResolved\
          comments(first:100){\
            nodes{\
              databaseId\
              author{login}\
              body\
              createdAt\
              path\
              line\
              originalCommit{oid}\
            }\
          }\
        }\
      }\
    }\
  }\
}' -F owner=<owner> -F repo=<repo> -F number=<pr_number>
```

Pagination requirement:
- Do not assume one page is enough.
- Paginate `reviewThreads` and nested comments until `hasNextPage=false`.
- If comments exceed a single page, continue fetching with `after` cursor.
- If pagination is incomplete or uncertain, report uncertainty and stop before proposing fixes.

Identify comments to review:
- Unresolved threads: include by default (including bot comments).
- Already addressed comments: skip when user/assistant already replied with `SHA` link(s) and no newer follow-up exists.
- Resolved bot threads: always skip (do not interfere).
- Resolved threads with follow-up: include only if there is a newer human follow-up after our `SHA` reply that requests further changes.

Present the list to user:
- Show total count of comments to review.
- For each: show author, date, and first 255 chars of content.
- Indicate if it is a new reply to our `SHA` post.
- Ask user to confirm to start review.
- Do not ask user to pick a batch of comments.

### Step 2 — Review each comment

Display the full comment (author, date, content, file/line reference, original commit `SHA`).

Assess validity:
- Is this a legitimate request?
- Is it actionable (can be fixed in code)?
- Is it out of scope?
- Is it a duplicate of another comment?
- Is it already addressed by existing commits?

State your assessment to user:

If VALID:
```text
[VALID] Comment by @author on <file>:<line>

Assessment: This is a valid suggestion.
Proposed approach: <brief idea>

Should I proceed with planning a fix? (yes/no)
```

React to the review comment with thumbs up (not a new comment):
```bash
gh api "repos/<owner>/<repo>/pulls/comments/<comment_id>/reactions" -X POST -H "Accept: application/vnd.github+json" -F content='+1'
```

If reaction already exists (`HTTP 422`), treat it as success and continue.

If NOT VALID:
```text
[NOT VALID] Comment by @author

Reason: <explain why not actionable>
- e.g., "Out of scope for this PR"
- e.g., "Won't fix because..."
- e.g., "This was already addressed in commit X"

Should I post a reply explaining this? (yes/no/reply-with-text)
```

React to the review comment with eyes (not a new comment) until the not-valid reason is posted:
```bash
gh api "repos/<owner>/<repo>/pulls/comments/<comment_id>/reactions" -X POST -H "Accept: application/vnd.github+json" -F content='eyes'
```

If reaction already exists (`HTTP 422`), treat it as success and continue.

If user approves posting the reply, post a reply and mark the thread as resolved after posting:
```bash
gh api "repos/<owner>/<repo>/pulls/<pr_number>/comments/<comment_id>/replies" -X POST -F body="<reason_text>"
```

User can override your assessment if they disagree.

Iteration rule for Step 2:
- Process comments one by one, never as a batch.
- For each comment, always provide an explicit verdict: `[VALID]` or `[NOT VALID]`.
- Wait for user decision on that comment before moving to the next one.
- Do not skip validity assessment and jump directly to implementation.

Per-comment state machine:
- Track each comment through: `validated -> planned -> approved -> committed -> replied -> resolved`.
- Never move a comment to the next state without completing the current one.
- Do not start the next comment until the current one reaches `resolved` or `skipped` by user.

### Step 3 — Plan fix (if valid)

User approved fixing this comment.

Iterate on the fix with the user:
- Understand the comment fully: read context, check referenced files/lines, look at related code.
- Make code changes locally.
- Show proposed changes to the user.
- Back-and-forth until user is satisfied with the changes.
- User can request modifications, and repeat until approved.

Once user approves the changes:
- Wait for explicit approval to proceed ("yes"/"proceed"/"go").

### Step 4 — Post fix

User gave explicit final approval to proceed.

Follow commit mapping and fixup rules from `~/.config/opencode/context/versioning.md` (`Commits` -> `Review fixups`).

Before pushing, report the commit plan to user and wait for explicit approval:
- `original_commit_sha_A` -> `fixup_sha_A` -> files/hunks included
- `original_commit_sha_B` -> `fixup_sha_B` -> files/hunks included
- `new_commit_sha_X` -> files/hunks included (only for genuinely new work)
- Proceed to push only after user confirms.

Mandatory pre-push check:
- Show a hunk-to-commit mapping table for all changed hunks.
- Confirm every fixup target `SHA` is in `<base_branch>..HEAD`.
- If mapping is uncertain for any hunk, stop and ask user before committing.

Pre-push safety checks:
- Show `git status --short` and `git log --oneline <base_branch>..HEAD` before pushing.
- Wait for explicit user approval immediately before `git push`.

Push the fixup(s):
```bash
git push origin <current_branch> --force-with-lease
```

Get the new `SHA`(s):
```bash
git log --format="%H" -n <number_of_fixups>
```

Post a REPLY to the original comment (not a new comment) using rules in `~/.config/opencode/context/github.md` (`Review replies and resolution`):
```bash
gh api "repos/<owner>/<repo>/pulls/<pr_number>/comments/<comment_id>/replies" -X POST -F body="<sha_link_1> & <sha_link_2> & ..."
```

For each resolved review comment, post only the corresponding fixup/new-work `SHA` link(s) to that specific comment.

Mark the comment thread as resolved:
```bash
# 1) Find the review thread node `ID` that contains this comment `ID`.
gh api graphql -f query='\
query($owner:String!, $repo:String!, $number:Int!){\
  repository(owner:$owner,name:$repo){\
    pullRequest(number:$number){\
      reviewThreads(first:100){\
        nodes{\
          id\
          comments(first:100){nodes{databaseId}}\
        }\
      }\
    }\
  }\
}' -F owner=<owner> -F repo=<repo> -F number=<pr_number>

# 2) Resolve the matching thread by node `ID`.
gh api graphql -f query='\
mutation($threadId:ID!){\
  resolveReviewThread(input:{threadId:$threadId}){\
    thread{isResolved}\
  }\
}' -F threadId=<thread_node_id>
```

Confirm to user:
- Show the `SHA` link(s).
- Show the reply was posted.
- Show the thread was marked as resolved.
- Ask to continue to next comment or finish.

### Step 5 — Finish

When all comments have been processed, re-request reviews from reviewers who commented:
```bash
# Get list of reviewers from review comments and filter bots/self.
gh api repos/<owner>/<repo>/pulls/<pr_number>/comments --jq '.[].user.login' | sort -u

# Re-request review from each reviewer.
gh pr edit <pr_number> --add-reviewer <reviewer1> --add-reviewer <reviewer2>
```

Do not request review from:
- Bot accounts.
- The current authenticated user.
- Users already requested in the PR reviewer list.

Provide a summary with links:
- `PR` link: `https://github.com/<owner>/<repo>/pull/<pr_number>`.
- List of resolved comments and their `SHA` links.
- List of not-valid comments with reasons (if any).
- List of reviewers re-requested.

Ask user if they want to do anything else.

## Rules

- Never execute remote-state actions (push, reply, resolve, re-request review) without explicit user approval.
- Never push review-fix commits to `main`/`master`.
- Post replies to existing review comments, not top-level `PR` comments.
- Follow commit/fixup rules from `~/.config/opencode/context/versioning.md` and reply/resolution rules from `~/.config/opencode/context/github.md`.
- If any command fails, show exact command and error, then stop and ask user.
