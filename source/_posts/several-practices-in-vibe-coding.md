---
title: several practices in vibe coding
date: 2026-04-07 21:57:43
tags:
---

# Vibe Coding: Evidence-Based Summary + Prompt Pack

## What I was thinking at the start

Your two observations are plausible, and there is meaningful public evidence behind them.

### 1) Why the same model may code worse than it reviews

My starting hypothesis was that **code generation** and **code review** are different cognitive tasks for an LLM.

- When the model is asked to **implement**, it has to search a large solution space, make design choices, manage format constraints, and avoid hidden bugs at the same time.
- When the model is asked to **review**, the search space narrows. It no longer needs to invent the solution from scratch; it only needs to **find contradictions, missing edge cases, unsafe assumptions, or broken logic**.
- This is consistent with research on **self-debugging** and with engineering guidance that treats **verification as easier and more reliable than one-shot generation**.

So the behavior you noticed is not weird. In many cases, it is exactly what we should expect.

### 2) Why two-model cross-review often works better

My second hypothesis was that two-model review can help because it creates:

- **role separation**: one model focuses on proposing a solution, another on attacking it;
- **error diversity**: different models often fail in different ways;
- **less self-anchoring**: a fresh reviewer is less attached to the original implementation choices;
- **better specialization**: one model may reason well, while another edits or critiques more precisely.

Public benchmark and team-practice evidence supports this pattern, with one important caveat:

> Two-model workflows often help, but they do **not** automatically beat a strong single-model workflow every time.

The main gain comes from **splitting planning, implementation, and review into separate steps**, not from model-count alone.

### 3) What follows from this in practice

My conclusion was:

- avoid pure one-shot vibe coding for non-trivial work;
- separate **plan**, **implement**, **test**, and **review**;
- use **self-review** by default;
- add **cross-model review** for high-risk changes;
- keep the human responsible for architecture, acceptance criteria, and final sign-off.

That is also where the strongest public team guidance converges.

---

## Practical recommendations

Use this as the default workflow for non-trivial coding tasks:

1. Ask the model to make a plan first.
2. Ask it to implement against explicit constraints.
3. Ask the same model to perform a hostile self-review.
4. Run tests, lint, typecheck, and, when relevant, browser or end-to-end checks.
5. Ask a second model to do an adversarial review on the diff and the test gaps.
6. Keep the human in charge of the final merge decision.

This is usually much more reliable than “build the whole thing from this rough description.”

---

## Prompt 1 — Planner / Implementer

Use this when you want the model to build something, but in a controlled way.

```markdown
You are my implementation partner.

Task:
[Describe the feature / bug / refactor clearly.]

Context:
- Relevant files/modules: [list them]
- Relevant constraints: [style rules, architecture rules, performance limits, security rules]
- Known pitfalls to avoid: [list them]
- Existing behavior to preserve: [list it]

Success criteria:
- [criterion 1]
- [criterion 2]
- [criterion 3]
- Tests that should pass: [list or describe them]

Process requirements:
1. First, produce a short implementation plan.
2. Call out ambiguities, risks, and likely failure points.
3. Then implement the smallest correct change that satisfies the success criteria.
4. Do not rewrite unrelated code.
5. Prefer simple, maintainable solutions over clever ones.
6. After implementation, provide:
   - a concise summary of what changed,
   - a list of files changed,
   - tests to run,
   - any residual risks or assumptions.

Output format:
- Section 1: Plan
- Section 2: Risks / assumptions
- Section 3: Implementation
- Section 4: Validation steps
- Section 5: Residual concerns
```

### When to use it

- New feature implementation
- Bug fix with multiple plausible solutions
- Refactor where you want the model to stay scoped

### Why this prompt works

It forces the model to separate **planning** from **editing**, reduces premature coding, and makes review easier later.

---

## Prompt 2 — Self-Review / Self-Debug Prompt

Use this immediately after the model writes code. The key is to switch the model from **builder mode** into **critic mode**.

```markdown
You are now acting as a strict code reviewer.

Review the implementation as if it was written by another engineer.
Do not defend it. Try to break it.

Your job:
1. Find correctness bugs.
2. Find edge cases and hidden assumptions.
3. Find race conditions, state inconsistencies, invalid error handling, or rollback issues.
4. Find security, performance, and maintainability risks.
5. Find missing or weak tests.

Review context:
- Original task: [paste task]
- Success criteria: [paste criteria]
- Code / diff to review: [paste code or diff]

Instructions:
- Be adversarial and specific.
- Do not give generic praise.
- Do not rewrite the whole solution unless a flaw requires it.
- For each issue, provide:
  - severity: critical / high / medium / low
  - location
  - why it is a problem
  - a concrete fix
  - a test that would expose it
- If you think the code is safe, say what you actively checked before concluding that.

Output format:
- Verdict
- Issues found
- Missing tests
- Recommended minimal fixes
- Confidence level
```

### When to use it

- After every non-trivial implementation
- Before handing code to a teammate
- Before asking a second model to review

### Why this prompt works

It changes the task from “produce code” to “falsify code.” That often gives better signal because the model no longer has to search the whole solution space.

---

## Prompt 3 — Cross-Model Adversarial Review

Use this with a second model. Give it the original task, the produced diff, and the self-review output.

```markdown
You are the second reviewer.
Your job is not to be polite. Your job is to find what the first model missed.

Materials:
- Original task: [paste task]
- Constraints: [paste constraints]
- Success criteria: [paste criteria]
- Proposed diff / code: [paste code or diff]
- First model self-review: [paste it]

Review goals:
1. Identify bugs, edge cases, and unsafe assumptions missed by the first model.
2. Check whether the implementation truly matches the stated requirements.
3. Look for overengineering, underengineering, or architecture drift.
4. Check test adequacy.
5. Challenge any claim made in the self-review that seems weak or unproven.

Important review angles:
- correctness
- concurrency / ordering / idempotency
- data integrity
- API compatibility
- backward compatibility
- failure handling
- observability / logging
- test coverage gaps
- performance regressions
- security risks

Instructions:
- Assume the implementation is flawed until proven otherwise.
- Prefer concrete findings over stylistic commentary.
- If you disagree with the self-review, explain why.
- If the code is acceptable, explain what would still make you nervous in production.

Output format:
- Final verdict
- Confirmed issues
- New issues missed by the first review
- Disagreements with the first review
- Additional tests required before merge
- Merge recommendation: yes / no / only after fixes
```

### When to use it

- High-risk changes
- Database, auth, payments, caching, concurrency, distributed systems
- Refactors that are hard to validate locally
- Any change where a silent bug would be expensive

### Why this prompt works

It reduces correlated blind spots and encourages an explicitly adversarial second pass instead of a shallow “looks fine.”

---

## Suggested lightweight workflow

For day-to-day work, a simple pattern is enough:

```markdown
A. Planner / Implementer
B. Same-model Self-Review
C. Run tests / lint / typecheck / smoke test
D. Second-model Adversarial Review
E. Human final decision
```

For very small changes, you can skip step D.
For high-risk changes, keep all five steps.

---

## Sources behind these recommendations

These recommendations are based on a mix of research papers and practitioner/team guidance:

1. **Chen et al. — Teaching Large Language Models to Self-Debug**  
   Shows that self-debugging can improve code-generation performance, including settings without unit tests and settings with test feedback.

2. **Aider — Separating code reasoning and editing**  
   Public benchmark showing gains from splitting architect/reasoning and editor roles, including some multi-model pairings.

3. **OpenAI Codex — Best practices**  
   Recommends plan-first workflows, explicit task structure, durable guidance, and validation.

4. **OpenAI Codex — Building an AI-Native Engineering Team**  
   Recommends separate test-generation steps, strong review loops, and keeping engineers responsible for final quality and merge decisions.

5. **Anthropic — Effective harnesses for long-running agents**  
   Shows that incremental work, explicit artifacts, and stronger testing tools materially improve agent performance.

6. **Salvatore Sanfilippo (antirez) — Coding with LLMs in the summer of 2025 (an update)**  
   Argues from personal practice that LLMs are strong amplifiers, useful in review and design, but that humans should remain in the loop for high-quality software.

---

## Final takeaway

If you remember only one rule, make it this:

> Do not treat vibe coding as a single prompt. Treat it as a workflow with separate roles: planning, implementing, testing, and reviewing.

That is where the best evidence and the most credible team practice currently converge.
