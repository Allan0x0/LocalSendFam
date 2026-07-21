---
name: issue-workplan
description: Fetches all open GitHub issues for the current repo and produces a prioritized workplan showing which issues can be worked on in parallel versus serially, to maximize developer productivity. Use when the user wants to plan their work, review open issues, figure out what to work on next, create a sprint plan, or asks about issue dependencies and parallelism.
---

# Issue Workplan

Fetch open GitHub issues, map their dependencies, and output a wave-based workplan.

## 1. Fetch issues

```bash
gh issue list --state open --json number,title,body,labels,milestone,assignees --limit 100
```

If the issue count is high, also check milestones for phase/ordering signals:

```bash
gh milestone list
```

## 2. Analyze dependencies

For each issue, scan for:

- **Explicit blockers** — body contains "blocked by #N", "depends on #N", "after #N closes", "requires #N"
- **Issue references** — any `#N` mention is a weak dependency signal; read context to determine direction
- **Labels** — labels like `phase-1`, `phase-2`, `blocked`, `epic`, or milestone names signal ordering
- **Implicit content logic** — "add UI for X" depends on "create API for X"; "write tests for Y" depends on Y being built; data-model issues gate everything that touches that model
- **Shared files / layers** — two issues that both modify the same schema or route are risky in parallel (flag, don't block)

## 3. Build the dependency graph

Group issues into **waves**:

- **Wave 1**: no blockers, no dependencies on open issues — start immediately, all in parallel
- **Wave 2**: blocked only by Wave 1 issues — start after Wave 1 merges
- **Wave N**: each subsequent wave unblocks once all its blockers are closed

Issues that touch the same file or surface go in **separate waves**, even when neither blocks the other. A merge conflict you avoid costs nothing; one you resolve costs a round trip through integration. Dependency order sets the floor for which wave an issue *can* be in; file isolation picks which of the eligible waves it lands in.

Still list them under **Shared-file risks** in the output, naming the wave each was pushed to and why — the driver checks that section before spawning.

## 4. Output the workplan

```
## Workplan — <repo> (<date>)

### Wave 1 — start immediately (parallel)
- #N  Title  [labels]
      → No blockers. One-line rationale for why it's foundational.

### Wave 2 — after Wave 1 (parallel within wave)
- #N  Title
      → Depends on #M (reason).

### Wave 3 — ...

### Shared-file risks
- #A and #B both touch <file/area> — coordinate merges.

### Notes
- Any ambiguous dependencies called out explicitly.
- Recommendation for team splitting if relevant (e.g., "one person on Wave 1 data-model issues, another on unblocked UI work").
```

## 5. Surface open questions

If dependency direction is ambiguous, state the ambiguity and ask the user to clarify rather than guessing. Better to pause than to mis-sequence work.
