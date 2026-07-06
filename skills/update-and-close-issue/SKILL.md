---
name: update-and-close-issue
description: Check for unfinished work, post a closing comment on a GitHub issue with a summary of what was done and links to relevant commits, then close the issue. Use when user types /update-and-close-issue or asks to "update and close the issue".
---

# Update and Close Issue

## Workflow

### 1. Identify the issue
- If the user provided an issue number, use it.
- Otherwise check the current branch name for a number (e.g. `feature/123-foo` → `#123`).
- If still unclear, ask the user.

### 2. Check for unfinished work
Run these in parallel:
- `git status` — any uncommitted changes?
- Search for `TODO`, `FIXME`, `HACK`, or `XXX` comments in files touched this session.
- Scan the issue's original task list (checkboxes) via `gh issue view <N> --json title,body,comments` — any unchecked items? (Plain `gh issue view` errors on Projects-classic GraphQL deprecation.)

If anything is unfinished, **stop and surface it to the user** before continuing. Do not close an issue with open work.

### 3. Gather relevant commits
```bash
git log --oneline origin/main..HEAD   # commits on this branch vs main
```
If the branch is already merged:
```bash
gh pr list --state merged --search "closes #<N>"
# then: git log --oneline <merge-commit>^..<merge-commit>
```
Collect the short SHAs and one-line messages for all commits that relate to this issue.

### 4. Compose the closing comment
Write a concise comment covering:
- **What was done** — 2–5 bullet points, focused on behaviour/outcome not implementation detail.
- **Commits** — list each short SHA as a link: `owner/repo@<sha>` (GitHub auto-links these).
- **Anything deferred** — if any sub-tasks were consciously left out, note them and reference a follow-up issue if one exists.

Template:
```
## Done

- <bullet 1>
- <bullet 2>

**Commits:** owner/repo@abc1234, owner/repo@def5678

<optional: Deferred: X was out of scope — tracked in #NN>
```

### 5. Post the comment and close
```bash
gh issue comment <N> --body "$(cat <<'EOF'
<your comment>
EOF
)"

gh issue close <N> --reason completed
```

Run the comment first; confirm it posted before closing.

### 6. Confirm
Report back:
- Issue URL
- Comment URL
- Closed status

## Safety rules
- Never close an issue with unchecked task-list items unless the user explicitly says to skip them.
- Never close if there are uncommitted changes — commit or stash first.
- If `gh` is not authenticated, surface the error and stop.
