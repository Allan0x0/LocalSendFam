---
name: work-issue
description: Work a single GitHub issue end-to-end inside the current worktree — route by logic/visual label, make the change (TDD for logic, direct for visual), commit, and self-check with anyleft. Use when invoked by the loop driver as "/work-issue <number>", or when the user asks to take one ready-for-agent issue to a committed, self-verified state without merging.
---

# work-issue — the loop's maker step

You are the **maker** in a maker≠checker loop. You take ONE GitHub issue from
`ready-for-agent` to a **committed, self-verified change inside the current git
worktree**. You do NOT merge to staging and you do NOT close the issue — the
driver owns those, with an independent checker. Your context is fresh and
disposable; the repo and the issue carry all durable state.

## Inputs
- `$ARGUMENTS` is the issue number (e.g. `15`). If absent, stop and say so.
- You are already `cd`'d into a dedicated worktree on branch `loop/issue-<n>`,
  branched from `staging`. Never touch the main checkout.

## Algorithm

0. **Bootstrap the worktree.** Fresh worktrees are routinely cut from a stale
   base and have no dependencies installed; fix both before touching the issue:
   - If `staging` has commits this branch lacks
     (`git rev-list --count HEAD..staging` > 0), run `git merge staging` —
     prerequisites from earlier issues live there.
   - If `node_modules` is missing, install with the package manager the
     lockfile names (`pnpm-lock.yaml` → `pnpm install`, `package-lock.json` →
     `npm install`, etc.).
   - If the project has a codegen/typegen step (e.g. `react-router typegen`,
     `prisma generate` — check `package.json` scripts), run it so typecheck
     can pass. Never skip the check gate later as a "pre-existing environment
     issue"; this step exists so the gate always has what it needs.

1. **Read the issue.** `gh issue view <n> --json title,body,labels`. Read the
   body fully — it is your spec and your acceptance criteria.

2. **Route on label** (deterministic — do not guess when a routing label is set):
   - **`logic`** → TDD path. Invoke the **`tdd`** skill: write the failing
     test(s) that encode the issue's acceptance criteria first, watch them fail
     (red), then implement until green. Keep the test in the path the issue
     names (or the conventional `tests/` dir for that package).
   - **`visual`** → direct-implementation path. Make the UI change. Do NOT write
     screenshot/Playwright code — visual judgment is the human's, against
     staging. But never claim done without seeing the change render: start (or
     restart — a stale dev server shows old code) the preview server, load the
     exact route the issue names, and confirm the new appearance is actually
     there. Partial restyles and wrong-route assumptions are the two failure
     modes this catches. If the issue has a Claude Design reference, compare
     against it and **include the design URL in your report** next to the issue
     number. If you need screenshots or visual references from the user, name
     exactly which pages/routes you need, unprompted — never stall waiting.
   - **`docs` / `documentation`** → prose path. Write or edit the document(s)
     the issue describes (Markdown, ADRs, READMEs, MOUs, plans). No tests, no
     typecheck — your bar is: the document satisfies every acceptance-criteria
     bullet, placeholders are clearly marked, and the prose is at the tone the
     issue specifies. Skip step 4's typecheck/test gate for this path.

   **No routing label present?** Don't stop — infer the kind from the issue
   body and title using these rules, in order:
   - Body asks for a Markdown/text document, plan, ADR, README, MOU, spec, or
     prose deliverable (mentions "draft", "write up", "one-pager", "letter",
     filename ending `.md`, etc.) → treat as **`docs`**.
   - Body names code paths, functions, data structures, or describes
     input→output behaviour that could be encoded as a test → treat as
     **`logic`**.
   - Body describes appearance, layout, styling, or a screen/component change
     → treat as **`visual`**.
   - **Genuinely ambiguous** (could plausibly be two of the above, or you
     can't tell what artefact to produce) → STOP. Output exactly
     `WORK_ISSUE_MALFORMED: cannot infer kind (no logic/visual/docs label)` and
     make no edits. The driver quarantines it.

   When you infer (rather than read a label), state the inferred kind in one
   line at the top of your reply (`Inferred kind: docs`) so the human can
   correct the routing by adding a label and re-running.

3. **Stay in scope.** Touch only what the issue requires. One issue = one
   coherent change. If you discover the issue depends on unmerged work, STOP and
   output `WORK_ISSUE_BLOCKED: <reason>`.

4. **Verify your own work** before committing:
   - For `logic` / `visual` paths: run the repo's typecheck and test commands
     (see `.claude/loop.config`: `TYPECHECK_CMD`, `TEST_CMD`). For a
     single-package change you may scope them to that package to save time, but
     the driver will run the full gate anyway.
   - For the `docs` path: skip typecheck/tests. Instead re-read the issue's
     acceptance-criteria checklist and confirm each bullet is satisfied by the
     document you wrote.
   - Fix until both pass (or the doc covers every bullet). If you cannot get
     there within your turn budget, commit work-in-progress (step 5) so the
     next fresh attempt resumes from it.

5. **Commit to the worktree branch** (never to staging/master):
   `git add -A && git commit -m "<type>(#<n>): <concise summary>"`.
   Commit even partial progress — the commit is how the next iteration resumes.

6. **Self-check with `anyleft`.** Invoke the **`anyleft`** skill against issue
   `<n>`. This is your own pre-flight, not the authoritative gate (the driver
   runs an independent `anyleft` with separate context as Gate 2). Append any
   gaps it finds to the issue as a comment so the next iteration sees them.
   Then go over your own work once as a reviewer would: re-read the full diff
   end to end and ask whether it would pass both the tests and the user's
   manual verification against the issue's acceptance criteria. Fix what
   wouldn't before reporting.

7. **Report a status token** as the final line of your output, so the driver can
   parse it deterministically:
   - `WORK_ISSUE_DONE: #<n>` — committed, typecheck+test green, anyleft clean.
   - `WORK_ISSUE_PARTIAL: #<n> <one-line reason>` — committed WIP, not yet green.
   - `WORK_ISSUE_MALFORMED: <reason>` / `WORK_ISSUE_BLOCKED: <reason>` — as above.

## Rules
- **Maker, not merger.** No `git merge`, no `git push`, no closing the issue.
- **Worktree-only writes.** Never edit outside the current worktree.
- **Failures feed the system.** When a pattern is wrong, leave the corrected
  pattern in the code or a note on the issue — the next fresh context discovers
  it. You debug the loop, not the run.
- Keep inter-iteration notes terse (caveman-style is fine) — they are state, not prose.
