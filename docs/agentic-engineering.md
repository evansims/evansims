---
title: Agentic Engineering — Evan Sims
header: Agentic Engineering Isn't Vibe Coding
byline: true
layout: default
---

Bring the engineering back.

"Vibe coding" has stopped meaning anything.

A year ago, when Andrej Karpathy popularized the term, it pointed to a specific behavior: prompt the model, accept what it gives you, paste errors back in until it runs. Useful for a hackathon demo. Honest about what it was.

Today the same two words cover everything from weekend hacks to disciplined workflows where agents write most of the code under human review. Those aren't the same thing. Lumping them together has produced exactly the confusion you'd expect, and the avoidable damage that follows.

Vibe coding, properly defined, is one specific behavior: you don't deeply review the code you're about to rely on. You prompt, accept the output, run it, see if it works. When it breaks, you paste the error back in and keep going. You're a prompt DJ, not an engineer.

That mode has real uses. Greenfield MVPs. Hackathon demos. Personal scripts you're fine regenerating if they break. Exploration where the output is learning, not a maintainable system. If vibe coding lets millions of people create software they never could have shipped before, that's a real win. It belongs in the toolbox.

The failure pattern is just as predictable. It demos beautifully, then reality arrives. The moment you try to change it, scale it, secure it, or hand it to someone else, nobody really understands what the system does. This isn't engineering. It's hoping.

A simple litmus test: if you can't explain the code you're shipping, or you don't have a way to prove it works beyond "it ran once," you're vibe coding.

The problem is not that vibe coding exists. The problem is that the term now describes practices that look nothing like it. Spec-first work. Reviewed diffs. Enforced tests. Staged rollouts. Production observability. Someone writes a spec, often with AI help, before any code gets generated. Every change is reviewed as if it came from a junior teammate. Tests aren't optional; they're the steering wheel. The model is treated like a fast, unreliable developer: useful, but never trusted blindly.

"AI-assisted engineering" is a decent umbrella for that space. Simon Willison suggested "vibe engineering," reclaiming "vibe" but adding "engineering" to signal discipline. Clever, but "vibe" still reads as casual to the people who own risk, uptime, and budgets. Karpathy's newer suggestion fits better: *agentic engineering*.

Agentic engineering is what it sounds like. You orchestrate agents that can generate code, run it, test it, and iterate, while you remain the architect, reviewer, and final decision-maker. Agents do much of the *implementation*. Humans own the *architecture* and quality. You may write only a fraction of the code by hand. The discipline stays the same as any critical system: design, review, testing, change control, observability, operations.

The term works because it's descriptive without being flippant. "Agentic" implies autonomy and iteration, not autocomplete. "Engineering" signals rigor. You can put it in a job description without making your CTO wince.

If you picture the spectrum:

- Vibe coding: disposable, demo-first, low review.
- AI-assisted engineering: AI accelerates; humans still implement a lot directly.
- Agentic engineering: agents implement; humans constrain, review, and sign off.

The workflow follows. Start with a plan: a design doc or spec, an architecture, work broken into tasks an agent can complete. Even a lightweight design beats no design. Delegate, then review like a PR. If you can't explain a module, it doesn't ship. Test relentlessly. Without tests, agents will confidently declare "done" on broken behavior. Keep accountability human. Code ownership, CI, incident response, and production monitoring stay your responsibility. Delegation never moves accountability.

A rule worth stating explicitly: the goal is not to make the agent right. The goal is to build a system where being wrong is *cheap to detect and safe to fix*.

This is also where agentic engineering fails. If specs are vague, tests are thin, and review becomes rubber-stamping, you don't get engineering faster. You get confusion faster.

Agentic engineering disproportionately benefits senior engineers. If you understand system design, security patterns, and performance tradeoffs, AI becomes a force multiplier. You spot bad abstractions early. You steer agents toward robust solutions.

If you're earlier in your career and lean on AI before you've built fundamentals, you risk *atrophy*. You can ship code without understanding it. You can deliver features without learning why certain patterns exist, or when they're dangerous. Many leaders are already worried about a generation of developers who can prompt but can't debug, generate but can't reason about what they shipped.

Agentic engineering isn't easier than traditional engineering. It's a different kind of hard. You trade typing time for review time. You trade implementation effort for orchestration skill. You spend more time reading, evaluating, and shaping code than writing it from scratch.

The fundamentals matter more, not less.

AI coding doesn't replace the craft of software engineering. It raises the bar for it. The people who thrive won't be the ones who prompt the fastest. They'll be the ones who think the clearest about what they're building and why, then use every tool, including agents, to build it well.

Vibe coding showed what's possible when you drop conventions. Agentic engineering is about bringing the engineering back, and naming that practice clearly.
