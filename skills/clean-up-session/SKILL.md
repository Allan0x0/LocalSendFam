---
name: clean-up-session
description: Wrap up a Claude Code session by safely removing a git worktree and its corresponding branch. Runs /anyleft first to check for unmerged work, verifies the worktree is eligible for deletion, then removes it and deletes the branch. Proposes workarounds if deletion is blocked. Use when user types "/clean-up-session", asks to "delete the worktree", "remove the branch", or wants to clean up after finishing a session.
---

# Clean Up Session

## Quick start

Run `/clean-up-session` when you're done with a feature branch and want to remove the worktree and its branch.

## Workflow

**Core promise:** this skill always either (a) removes the worktree AND deletes the branch, or (b) tells the user exactly which of `{worktree, local branch, remote branch}` is still around and the specific reason it could not be removed. Never finish with an ambiguous "done" — the final report (see end) is mandatory.

**Completion gate — you have NOT finished this skill until the Step 5 Cleanup report is printed.** A run that ends after any earlier step (including after `/anyleft` returns) is an incomplete, failed run. `ANYLEFT: PASS` is NOT a stopping point — it is the signal to start the removal work, not to report success. Do not let the `/anyleft` sub-skill's output become your final message; the moment it returns, continue to Step 2 and run straight through Step 5 in the same turn.

`/anyleft` passing is a precondition, not the finish line. After it passes, immediately proceed to step 2 and continue all the way through step 5.

### Step 1 — Check for unfinished work

Run `/anyleft` to verify there's no remaining work tied to the issue. If `/anyleft` reports unresolved items, **stop and surface them to the user** before continuing. Do not proceed unless the user explicitly confirms they want to clean up anyway.

If `/anyleft` reports `ANYLEFT: PASS`, **do not stop or summarize — that is not the end of the skill.** Proceed directly to Step 2 in the same turn and carry on through the Step 5 report. Stopping here is the single most common way this skill fails.

### Step 2 — Identify the worktree and branch

```bash
git worktree list
```

Determine:
- The path of the current (or target) worktree
- The branch it's checked out on
- Whether it's the **main worktree** (cannot be removed)

If you're in the main worktree, inform the user — nothing to clean up here.

### Step 3 — Eligibility checks

Run these checks and collect all failures before reporting. Don't stop on the first one.

| Check | Command | Blocker if... |
|---|---|---|
| Worktree is clean | `git -C <path> status --porcelain` | Has uncommitted changes or untracked files |
| Worktree is not locked | `git worktree list --porcelain` | Shows `locked` for the target worktree |
| Branch is merged | `git branch --merged main` or `git branch --merged staging` | Branch not in merged list |
| Branch not checked out elsewhere | `git worktree list` | Another worktree is on the same branch |

### Step 4 — Perform the removal (always attempt all three artifacts)

You **must** attempt each of the three removals below in order, even if an earlier one fails. Don't bail after the first error — keep going so the final report can tell the user the full state.

Step out of the worktree first (`cd` into the main checkout) before running these — you cannot remove the worktree you're sitting in.

```bash
# 1. Remove the worktree
git worktree remove <path>

# 2. Delete the local branch
git branch -d <branch-name>

# 3. Delete the remote branch IF it exists
git ls-remote --heads origin <branch-name>   # check first
git push origin --delete <branch-name>       # only if the check returned a line
```

Capture the success/failure of each step independently for the final report.

### Step 4b — When a removal is blocked

If a removal fails or an eligibility check flagged a blocker, **do not escalate to `--force` / `-D` without explicit user confirmation.** Record the exact reason and the suggested workaround for the final report:

| Failure | Reason to record | Workaround to suggest |
|---|---|---|
| Uncommitted changes | "worktree has uncommitted changes: <files>" | Commit or stash them, or `git worktree remove --force <path>` if throwaway |
| Locked worktree | "worktree is locked" | `git worktree unlock <path>` then retry |
| Branch not merged into base | "branch not merged into <base>" | Push and open a PR, merge it, then retry — or `git branch -D <branch>` if abandoned |
| Branch checked out elsewhere | "branch also checked out at <other-path>" | Switch that worktree to another branch first |
| Remote delete rejected | "remote delete rejected: <git error>" | Inspect remote ref protection / permissions |
| You're in the main worktree | "main worktree — not removable" | Nothing to do; main worktree stays |

Always explain the risk when suggesting `--force` or `-D` options. Never run them without explicit user confirmation.

### Step 5 — Final report (mandatory)

End every run with a status block listing all three artifacts and one other check, so the user can see at a glance what remains. Use these exact labels:

```
Cleanup report:
  Worktree <path>:           removed | NOT removed — <reason>
  Local branch <name>:       deleted | NOT deleted — <reason>
  Remote branch <name>:      deleted | not present | NOT deleted — <reason>
  Current directory:         <where the shell is now>
```

Rules for the report:
- Print it even on full success — the user should always see the artifact list.
- If a row is `NOT …`, append the one-line workaround command the user can run themselves.
- If you escalated to `--force` or `-D` with explicit user consent, say so on the relevant row (e.g. `removed (--force, per user consent)`).
- If `/anyleft` failed and the user declined to proceed, the report is just one line: `Cleanup aborted — anyleft FAIL, user declined to override.`

## Notes

- The **main worktree** (`git worktree list` shows it without a path qualifier) can never be removed with `git worktree remove`. If the user is in the main worktree, there's nothing to clean up.
- `git branch -d` (lowercase) is safe — it refuses to delete unmerged branches. Only use `-D` (uppercase/force) when the user has confirmed the work is intentionally discarded.
- After removing a worktree, run `git worktree prune` if stale refs remain.
