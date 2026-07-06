---
name: commit-and-merge
description: Stage, commit, and merge all relevant session changes into the staging branch (or main/master if staging doesn't exist), then push the merge target to its remote. Generates a commit message from the diff, and finishes with detailed instructions for testing everything done during the session. Use when user types /commit-and-merge.
---

# Commit and Merge

## Workflow

### 1. Inspect current state
Run these in parallel:
- `git status` — find all tracked/untracked changes
- `git diff HEAD` — understand what changed
- `git log --oneline -5` — match existing commit message style
- `git branch -a` — detect available branches

### 2. Stage relevant changes
- Stage all files modified or created in this session
- **Skip silently:** `.env*`, `*.pem`, `*credentials*`, `*secrets*`, `*.key`, build artifacts (`dist/`, `.next/`, `node_modules/`)
- If unsure whether a file belongs, include it and note it in the commit message

### 3. Draft commit message
- Use conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`
- Subject line ≤ 72 chars; focus on *why*, not *what*
- Append trailer:
  ```
  Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
  ```
- Use a HEREDOC when passing to `git commit -m`

### 4. Commit
- Run `git commit`
- If a pre-commit hook fails: fix the issue, re-stage, create a **new** commit — never `--no-verify`

### 5. Detect merge target
```bash
git branch -a | grep -E '^\*?\s*(staging|remotes/origin/staging)' 
```
- Use `staging` if it exists locally or on remote
- Fall back to `main`, then `master`

### 6. Merge — never check out the target from a worktree
The target branch is normally checked out in the main worktree, so `git checkout <target>` from a session worktree fails with `fatal: '<target>' is already used by worktree at ...`. Run the merge in the checkout that already holds the target instead of switching branches:

1. Note the current branch name (the worktree branch you must end on).
2. Find where `<target>` is checked out: `git worktree list`. Call that path `<main>`.
   - If no checkout holds `<target>` (e.g. you are in a plain single-checkout repo), check it out here, merge, and switch back — the rest of this step still applies with `<main>` = the current directory.
3. Confirm `<main>` is clean: `git -C <main> status --porcelain` prints nothing. Dirty → report ⏭️ Not merged (reason: main checkout has uncommitted changes) and stop the merge.
4. Sync the target: `git -C <main> pull --ff-only origin <target>`. If it fails (divergence, auth, no remote), report ⏭️ Not merged with the exact error — never resolve divergence on the target with a surprise merge commit.
5. Merge the session branch: `git -C <main> merge <session-branch>` (fast-forward if possible).
6. On conflict: resolve simple ones in `<main>`, commit the merge there; surface complex ones to the user before proceeding.

Because the merge runs via `git -C <main>`, the session worktree never leaves its branch.

**Always report the merge outcome — never skip silently.** After this step, state one of:
- ✅ **Merged:** `<source>` → `<target>` (N commits, fast-forward / merge commit `<sha>`)
- ⏭️ **Not merged — <reason>.** Use this for any case where the merge did not complete, and name the reason explicitly so the user can investigate or do it manually. Common reasons:
  - Working tree was clean — nothing to commit or merge
  - Main checkout (`<main>`) has uncommitted changes
  - `git -C <main> pull --ff-only origin <target>` failed (divergence, no remote, auth, or network)
  - Source branch already up to date with target (nothing to merge)
  - Merge conflict surfaced to the user and not yet resolved
  - Target branch could not be detected
- If you report "Not merged", also give the one-line command the user can run to finish it manually (e.g. `git -C <main> merge <source>`).

### 7. Push the merge target
- After a successful merge, push from the same checkout: `git -C <main> push origin <target>`
- If the push is rejected non-fast-forward (a parallel session pushed first): `git -C <main> pull --ff-only origin <target>`, then retry the push **once**
- Report the outcome: ✅ **Pushed:** `<target>` → `origin/<target>` (`<sha>`), or ⏭️ **Not pushed — <reason>** (e.g. push rejected after retry, no remote) with the manual command to finish it
- If nothing was merged in step 6, skip pushing

### 8. Confirm final branch
- Run `git branch --show-current` and confirm it matches the original worktree branch (with the `git -C <main>` flow it should never have changed)
- If it doesn't, switch back to it — never leave the user on the staging/main branch

### 9. Show how to test this session's work
After reporting the merge/push outcome, always end with a **"How to test this"** section. These instructions must be specific to what actually changed this session — never a generic template. Derive them from the session's work and the committed diff, not from memory alone.

Cover, in this order, only the parts that apply:
- **Prerequisites** — exact setup needed before testing: branch to be on (or `git pull` to sync the local merge target if it lagged behind the remote), env vars, services to start, dependencies to install (e.g. `npm install` when `package.json` changed), seed/migration/data steps. Give the real commands.
- **Automated checks** — the actual commands to run (e.g. `npm run typecheck`, `npm test`, lint), and whether they passed this session.
- **Manual verification, per feature/change** — a numbered walkthrough for each distinct thing built or fixed. For each: the exact route/URL, page, or command to exercise it; the precise actions to take; and the **expected result** so the user knows what "working" looks like. Include the bug-reproduction path for anything that was a fix ("before: X errored; now: Y"), and edge cases worth checking.
- **What was verified vs. not** — state plainly which steps you already confirmed during the session (and how) and which the user still needs to check themselves, so they don't re-test what's proven or assume something untested works.

Keep it concrete and copy-pasteable: real file paths, real URLs, real commands. Reference touched files as clickable links where useful. If literally nothing testable changed (e.g. docs only), say so in one line instead.

**Write the walkthrough in plain language and include every step**, even the obvious ones: starting the app, which URL to open, which account to log in with, what to click, and what the screen should show after each action. Number the steps. No jargon; if a technical term is unavoidable, gloss it in the same sentence. The bar: someone who didn't watch the session can follow it without asking a single question.

## Safety rules
- Never `--no-verify`, `--force`, or `--no-gpg-sign`
- Never commit `.env`, `*.pem`, secrets, or credentials — warn the user if they ask
- Never amend a published commit — always create a new one
- If the working tree is clean, say so and stop
