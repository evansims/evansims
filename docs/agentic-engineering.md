---
title: Agentic Engineering — Evan Sims
header: Agentic Engineering
byline: true
layout: default
---

A year ago, Andrej Karpathy popularized "vibe coding" to describe a deliberately loose way to write software with AI: you prompt, hand the keyboard to the model, accept whatever it gives you, don't really review the diffs, and keep pasting errors back in. It's great for getting something running in a hurry.

Since then, "vibe coding" has turned into a suitcase term. People now use it for everything from weekend hacks to disciplined workflows where agents write most of the code under human oversight. Those are not the same thing, and lumping them together is creating confusion, and avoidable damage.

## What "vibe coding" really is

When I say "vibe coding" here, I mean one specific behavior: you don't deeply review the code you're about to rely on.

- You prompt, accept the output, run it, and see if it works.
- When it breaks, you paste the error back in and keep going.
- You're effectively a prompt DJ, not an engineer.

This approach is genuinely useful when the code is intentionally disposable:

- Greenfield MVPs, prototypes, hackathon demos—when the deadline matters more than the diff.
- Personal one-off scripts you're fine regenerating if they break.
- Exploration and brainstorming—where the real output is learning, not a maintainable system.

If vibe coding lets millions of people create software they never could have shipped before, that's a real win. It belongs in the toolbox.

The failure pattern is predictable: it demos beautifully, then reality arrives. The moment you try to change it, scale it, secure it, or hand it to someone else, you discover nobody really understands what the system does. "This isn't engineering, it's hoping."

A simple litmus test: if you can't explain the code you're shipping (or you don't have a way to prove it works beyond "it ran once"), then you're vibe coding.

## Why we need a different term

The problem is not that vibe coding exists. The problem is that people now use "vibe coding" to describe practices that look nothing like it: spec-first work, reviewed diffs, enforced tests, staged rollouts, production observability.

In those workflows:

- Someone writes a spec (often with AI help) before any code gets generated.
- Every change is reviewed as if it came from a junior teammate.
- Tests aren't optional; they're the steering wheel.
- The model is treated like a fast, unreliable developer: useful, but never trusted blindly.

"AI-assisted engineering" is a decent umbrella for that whole space. Simon Willison suggested "vibe engineering," reclaiming "vibe" but adding "engineering" to signal discipline. It's clever, but "vibe" still reads as casual to the people who own risk, uptime, and budgets.

What's been missing is a term that clearly separates playful, disposable coding from serious, AI-heavy engineering that still respects rigor and risk. Karpathy's newer suggestion—*agentic engineering*—hits that mark.

## What is agentic engineering?

Agentic engineering is what it sounds like: engineering work where you orchestrate agents that can generate code, run it, test it, and iterate — while you remain the architect, reviewer, and final decision-maker. In short: agents do much of the implementation; humans own the architecture and quality.

- You may write only a fraction of the code by hand; agents produce the rest under direction.
- The discipline stays the same as any critical system: design, review, testing, change control, observability, and operations.

The term works because:

- It's descriptive: "agentic" implies autonomy and iteration, not just autocomplete; "engineering" signals rigor.
- It's professionally legible: you can put it in a job description or a team practice without sounding flippant.
- It draws a clean line: vibe coding is speed-first by design; agentic engineering is "AI implements, humans verify."

If you picture a spectrum:

- Vibe coding: disposable, demo-first, low review.
- AI-assisted engineering: AI accelerates; humans still implement a lot directly.
- Agentic engineering: agents implement; humans constrain, review, and sign off.

## How agentic engineering works in practice

The workflow is straightforward, but it deliberately embraces the discipline vibe coding sets aside.

- Start with a plan. Write a design doc or spec, define architecture, and break work into tasks that an agent can actually complete; even a lightweight design beats no design.
- Delegate, then review. Give agents narrow tasks, then review the output like a PR; if you can't explain a module, it doesn't ship.
- Test relentlessly. A good test suite lets agents iterate safely; without tests, agents will confidently declare "done" on broken behavior.
- Keep accountability human. Code ownership, documentation, CI, incident response, and production monitoring stay your responsibility; delegation never moves accountability.

A rule worth stating explicitly: the goal is not to make the agent "right." The goal is to build a system where being wrong is cheap to detect and safe to fix.

This is also where agentic engineering can fail. If specs are vague, tests are thin, and review becomes rubber-stamping, you don't get "engineering faster" — you get confusion faster.

## The emerging skill gap

There's an uncomfortable reality: agentic engineering disproportionately benefits senior engineers.

- If you understand system design, security patterns, and performance tradeoffs, AI becomes a force multiplier.
- You can spot bad abstractions early and steer agents toward robust solutions.

If you're earlier in your career and lean on AI before you build fundamentals, you risk skill atrophy.

- You can ship code without understanding it.
- You can deliver features without learning why certain patterns exist—or when they're dangerous.

Many leaders are already worried about a generation of developers who can prompt but can't debug, generate but can't reason about what they shipped.

Agentic engineering isn't "easier" than traditional engineering. It's a different kind of hard.

- You trade typing time for review time.
- You trade implementation effort for orchestration skill.
- You spend more time reading, evaluating, and shaping code than writing it from scratch.

The fundamentals matter more, not less.

## Where we go from here

AI agents are getting more capable, and agentic engineering is becoming increasingly common in professional teams. That trend will accelerate.

To make the most of it, we need:

- Honest terminology: call it agentic engineering when you mean disciplined, agent-driven implementation with human oversight; keep "vibe coding" for the prototype-only mode where you're explicitly not investing in long-term maintainability.
- Better evaluation frameworks: measure reliability, not vibes — change failure rate, MTTR, and security incidents matter more than demo speed.
- Investment in fundamentals: as agents take on more implementation, the premium on architecture, security, and systems thinking rises; education, mentoring, and training need to catch up.

AI coding doesn't replace the craft of software engineering; it raises the bar for it. The people who thrive won't be the ones who prompt the fastest, but the ones who think the clearest about what they're building and why — then use every tool, including agents, to build it well.

Vibe coding showed what's possible when you drop conventions. Agentic engineering is about bringing the engineering back, and naming that practice clearly.
