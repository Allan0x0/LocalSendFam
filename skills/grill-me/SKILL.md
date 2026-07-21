---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time. When two or three questions are genuinely independent (the answer to one cannot change the others), batch them in a single turn instead.

Use plain language throughout. Define every term of art the first time you use it, in the same sentence ("a DSL, meaning a small language built for one specific job"). Never lean on jargon or a coined phrase the reader hasn't been given the plain meaning of. Options must say what each choice does, not what it's called.

If a question can be answered by exploring the codebase, explore the codebase instead.

Push every decision down to something observable — a route, a command, a status code, a rendered string, a stored value. When an answer leaves a question that a later implementer would have to guess at ("what happens on a wrong code?", "how does the user reach that screen?", "how fast is fast enough?"), ask it now. This session is the cheapest place in the pipeline to answer it; every later stage answers it by guessing.
