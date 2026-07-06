---
name: work-wave
description: Drive a whole dependency wave of GitHub issues to merged-into-staging in one session — spawn a work-issue maker subagent per issue in its own worktree (parallel), verify each committed, merge them into staging in dependency order resolving conflicts, run the check gate, then pause for your manual verification before closing issues and cleaning up worktrees. Use when the user says "/work-wave", "run this wave", "work these issues in parallel", or hands you a wave from /issue-workplan.
---

# work-wave — the parallel wave driver

You are the **driver** in a maker≠checker loop, scaled from one issue to a whole
wave. Each issue's change is made by a disposable `work-issue` maker subagent in
its own worktree; you are the checker and integrator. The makers never merge and
never close — you do, only after their work is verified and the human has signed
off on a manual pass.

This is the parallel analogue of the old serial pipeline
(`work-issue` → `commit-and-merge` → manual verify → `update-and-close-issue` →
`clean-up-session`, one issue per session). The **one genuinely new concern** is
integration: N branches cut from the same base and built at once collide on
shared files, where serial one-at-a-time merges never did. That collision
handling is Phase 3; everything else is your existing single-issue skills in a loop.

## Input

`/work-wave <n1> <n2> <n3> …` — the issue numbers of one wave.

If no numbers are given, run `/issue-workplan` first and take **Wave 1** (the
unblocked issues). Never run issues from different waves together — a later
wave's blockers must be merged first. If asked to "run the next wave," confirm
the prior wave's issues are closed before starting.

Record the wave's **dependency order** now (from the workplan or the issues'
`blocked by`), because Phase 3 merges in that order.

## Phase 1 — spawn the makers (parallel)

**Before spawning anything, put the main checkout on a fresh base** so every
worktree is cut from the right commit instead of a stale `main`:
`git checkout staging && git pull --ff-only origin staging`. If the pull fails,
stop and surface it — spawning a wave from a stale or diverged base wastes
every maker.

Spawn one background agent per issue, each with `isolation: worktree` so they
can't collide mid-flight, each running the maker skill:

- subagent instruction: invoke the `work-issue` skill with the issue number;
  follow it exactly (its step 0 bootstraps the worktree: merge in missing
  `staging` commits, install deps, run typegen); commit on the worktree branch;
  **do NOT merge**; run `anyleft` and report branch, what was built,
  test/typecheck results, and the done-vs-remaining punch-list.
- `run_in_background: true`. You'll be notified as each finishes.

Do not spawn more than one agent per issue. Do not do the maker work yourself.

## Phase 2 — verify each maker actually landed (trust-but-verify)

**A "completed" notification is not proof of a commit.** A maker can be killed
mid-work (session/usage limit) and still report "completed" with nothing
committed. Before integrating, check each worktree's ground truth:

```bash
for wt in .claude/worktrees/agent-<id>; do
  git -C "$wt" log --oneline -1        # is there a feat(#N) commit?
  git -C "$wt" status --short | wc -l  # 0 = clean, >0 = uncommitted/unfinished
done
```

For each issue, classify:
- **Committed + clean** → ready to integrate.
- **Uncommitted work present** → the maker was cut off. Resume it with
  `SendMessage` to its `agentId` (its worktree and half-done work are intact):
  tell it the limit interrupted it, its work is uncommitted but safe, and to
  finish → run the check gate → commit → `anyleft`. Re-verify when it returns.
- **No change at all** → the maker failed. Read its punch-list, decide whether to
  re-spawn or hand back to the user.

Do not proceed to Phase 3 until every issue is committed + clean, or the user
has explicitly dropped one from the wave.

## Phase 3 — integrate into staging (the new step)

On the main checkout, on `staging`, working tree clean. Merge the worktree
branches **in dependency order** (blockers before dependents):

```bash
git merge --no-ff worktree-agent-<id> -m "Merge #N: <title> into staging"
```

- Merge the isolated / zero-shared-file issues first, the ones touching shared
  surfaces last — that front-loads the clean merges and isolates conflicts.
- On a conflict: read both sides, resolve by intent (not by picking a side
  blindly). Typical wave conflicts are two issues adding to the same route table
  or the same component — keep both additions; when one issue rewrote a function
  the other only added a call to, keep the rewrite and re-point the call. Prefer
  the canonical value from the earlier-merged issue over a later issue's
  redundant local recomputation.
- After the last merge, run the **full check gate once** on integrated staging:
  `pnpm db:generate` (fresh state), then `pnpm typecheck` and `pnpm vitest run`
  (use the project's own commands — read `package.json`; never assume npm).
  Grep for leftover conflict markers (`^<<<<<<<`). Both gates green + zero
  markers before continuing.
- Watch for **integration gaps no single issue owned**: a route built by issue A
  that nothing links to because the entry screen belongs to issue B. These pass
  every per-issue check and still dead-end the flow. Fix them here with a small
  bridge commit; they're the cost of parallel work.

## Phase 4 — hand off for manual verification (human gate, do NOT skip)

Integration being green is not "done" — the human still verifies on staging, the
same checkpoint the serial flow had. Produce **one consolidated runbook**, not N:

- How to boot the app locally (DB, migrations, dev server, any console-printed
  login/OTP — read the code, don't guess).
- Per issue: the exact path to exercise it and what "correct" looks like, drawn
  from its acceptance criteria. Call out anything gated (auth/payment) and how to
  get past the gate. For backend-only issues with no UI (e.g. a cost guard), say
  so and point at the interface test as the verification of record. For visual
  issues, put the Claude Design URL next to the issue so the human can compare
  in one click.
- Write the runbook in plain language with every step numbered and spelled out
  (start command, URL, login, click, expected result) — no jargon, no skipped
  "obvious" steps. The bar: followable without asking a single question.

Then **stop and wait** for the user to confirm. Do not close issues or delete
worktrees until they say the manual pass is good. If they report a defect, route
it back to the relevant maker (`SendMessage`) or fix inline, then re-verify.

## Phase 5 — close out (loop the single-issue skills)

Only after the user confirms verification. For each issue in the wave:

1. `/update-and-close-issue <N>` — post the closing summary + commit links, close it.
2. `/clean-up-session` for that worktree — it runs `anyleft` first, then removes
   the worktree and deletes the branch. If it reports blocking unmerged work,
   stop and surface it; that means Phase 3 missed something.

Finish with a one-screen wave report: issues closed with their merge commits,
any follow-up issues filed (gaps a maker found but didn't own), and what the
newly-merged wave unblocks next.

## Guardrails

- **Never close an issue before the human verification gate.** Green tests are
  the maker's bar; the human pass is yours.
- **Never merge across waves.** A dependent whose blocker isn't merged yet is not
  in this wave.
- **Trust-but-verify every maker** (Phase 2). This exists because it has already
  caught silent no-op "completions."
- **Reuse, don't reinvent:** the makers are `work-issue`, close-out is
  `update-and-close-issue` + `clean-up-session`, planning is `issue-workplan`.
  This skill is only the driver + the integration step between them.
