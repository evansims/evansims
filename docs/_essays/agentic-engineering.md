---
title: Agentic Engineering Isn't Vibe Coding
topic: AI
updated: 2026-04-29
description: "The discipline that separates agentic engineering from vibe coding: plans, reviews, tests as a gate, and limits on what the agent can touch."
---

Make being wrong cheap.

"Vibe coding" now names two different practices, and which one you're doing decides whether you can trust what ships.

Andrej Karpathy coined the term in February 2025 for one specific habit: prompt the model, accept what it gives you, and feed the errors back until it runs. That habit has real uses, like a hackathon demo or a personal script you wouldn't mind regenerating. Since then the same two words have stretched to cover teams where agents write most of the code under a spec, a test suite, and human review. Karpathy's newer name for that second practice fits better: *agentic engineering*.

My test for which side you're on is short. Can you explain the code you're about to ship, and can you prove it works beyond "it ran once"? If either answer is no, you're vibe coding, whatever you call it.

The discipline on the other side is the ordinary kind. Write the plan before the agent writes code. Read every change the way you'd read a new teammate's pull request. Make the tests a gate, because an agent will report "done" on broken behavior without hesitating. Keep the pager, too. Delegating the typing doesn't move the accountability.

You won't make the agent right every time. Build the system so its mistakes are *cheap to detect and safe to fix*.

I'd add one discipline from my own field. Decide what the agent can touch before it starts. Review catches a bad change after the agent wrote it. Scoped access limits what a bad change can reach in the first place. An agent that edits one service shouldn't hold credentials for the deploy pipeline, and a guardrail the agent can edit is one it can remove.

This site runs on a small version of that. An agent writes many of the changes. The deploy workflow runs the test suite first, and a failing test blocks the publish, so a wrong change stops before a reader sees it.

The work shifts from writing code to reading it, and reading is the part that takes years to learn. That favors engineers who already know what a bad abstraction looks like. It's a risk for anyone leaning on an agent before they've built that judgment.

If your team is adopting agents this year, start with the test gate and the access scope. Both keep working on the day nobody has time to read every diff.
