---
name: anyleft
description: Check if there's any work left to complete a GitHub issue — verifies explicit and implied success criteria, runs tests/lint/typecheck, and reports a done-vs-remaining punch list. Use when user asks "/anyleft", "is there anything left", "what's left on this issue", or "am I done with issue #N".
---

# Any Left?

## Quick start

Run `/anyleft` or `/anyleft #42` to check if a GitHub issue is fully resolved.

## Workflow

1. **Identify the issue**
   - If a number is given, fetch `gh issue view <N> --json title,body,labels,comments` (plain `gh issue view` errors on Projects-classic GraphQL deprecation)
   - If no number, check branch name and recent commits for an issue reference, then ask the user
   - Read the full issue body

2. **Extract success criteria**
   - Explicit: acceptance criteria, checklists, "done when..." statements in the issue body
   - Implied by issue type (see table below)
   - Check for linked sub-issues or PRs that must be merged first

3. **Inspect the code**
   - `git diff main...HEAD` — scope of changes on this branch
   - `git status` — any uncommitted work
   - Scan the diff for introduced TODO/FIXME/HACK comments

4. **Run quality gates** (in order; report failures, don't stop early)
   - Typecheck: `pnpm typecheck` (fall back to `npm run typecheck` / `yarn typecheck`)
   - Lint: `pnpm lint`
   - Tests: `pnpm test`

5. **Report** — punch list under 200 words, ending with a machine-readable verdict token

## Output format

```
Issue #N: <title>

Done:
  ✓ ...

Still needed:
  ✗ ...

Quality gates:
  ✓ typecheck
  ✓ lint
  ✗ tests — 2 failing

ANYLEFT: FAIL
```

### Verdict token (required — always the LAST line)

End every run with exactly one of these, on its own final line, so callers
(e.g. the loop driver's Gate 2) can parse the result deterministically instead
of scraping prose:

- `ANYLEFT: PASS` — every explicit and implied success criterion is met AND all
  quality gates (typecheck, lint, tests) pass. The "Still needed" list is empty.
- `ANYLEFT: FAIL` — anything remains: a missing criterion, a failing gate, an
  uncommitted change, or an introduced TODO/FIXME.

Emit nothing after the token. When in doubt, `FAIL` — a false PASS is far more
costly than a false FAIL, because it lets incomplete work through the gate.

## Implied criteria by issue type

| Type     | Implied criteria                                           |
|----------|------------------------------------------------------------|
| Bug      | Repro steps no longer reproduce; no regression nearby      |
| Feature  | Happy path works; edge cases from issue body covered       |
| Refactor | All existing tests pass; no new TODOs introduced           |
| Docs     | Referenced code still matches descriptions; links valid    |
| Chore    | CI passes; no leftover scaffolding or temp files           |
