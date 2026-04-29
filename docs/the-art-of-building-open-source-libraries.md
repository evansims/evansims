---
title: "The Art of Building Open Source Libraries — Evan Sims"
header: "Open Source Is Service to Strangers"
byline: true
layout: blog
---

Build for the developer you'll never meet.

A library is a contract with people you can't see. They'll arrive at 2am with a bug, in a stack you didn't anticipate, with a version of Node you've never tested. They'll judge the library in the first ninety seconds and either keep going or close the tab. The whole job is making those ninety seconds work.

Most of what makes a great library has nothing to do with the cleverness of the code. It comes from a few principles, each of which trades short-term effort for long-term *trust*.

The first is empathy. Great libraries don't get designed in isolation. They start with the developers who will use them: their environment, their habits, the daily friction they've come to accept. The job is to step into that world for long enough to notice where your library could remove a real ache, not an imagined one. That means installation that just works on the platforms your users actually use. Documentation that answers their question, not the one you wished they'd ask. APIs that read the way they think. Dependencies that don't leak surprises. Implementations they could read and verify if they had to. Empathy isn't a feeling. It's a practice you do over and over again, in code review, in issue triage, in the design of every new entry point.

The second is restraint. The hardest design question for any library is *what to leave out*. Every feature you ship is a feature you have to maintain forever, document forever, and explain to confused users at midnight forever. Treat the API surface as a budget, not a wishlist. When considering a feature, ask whether it actually simplifies what users came here to do, or whether it's adding a burden the developer didn't ask for. A library that says no to the right things ends up doing the right things very well.

The third is convention. A library feels right when it aligns with the conventions a developer already knows. Follow the established patterns of the language ecosystem. Provide examples drawn from real use, not toy demos. Behave consistently across functions, modules, and versions, so that learning one part teaches the next. Surprising the user is sometimes a deliberate design choice. Almost always, it's a bug.

The fourth is documentation. The goal of docs isn't to demonstrate complexity. It's to remove *uncertainty*. Quick-start guides that get someone to a working line of code in five minutes. Examples that match what people actually want to do. Reference material complete enough to trust, dense enough to be useful. When the docs and the library disagree, the docs are wrong. Fix them at the same speed you fix the code.

The fifth is errors. A library is judged most harshly when something goes wrong. That's the moment users decide whether they trust you. Error messages should describe what went wrong, in language that maps to what the developer was trying to do. They should hint at the fix. They should be consistent across the library, so once a developer learns to read your errors, they can read all of them.

The sixth is community. Communities around libraries don't appear spontaneously. They grow because someone tended them. Welcome contributors. Acknowledge their work openly. Give clear, respectful feedback in reviews. Reward improvements that came from outside the original team. The best contributors don't show up because of your roadmap. They show up because they felt *invited*.

When you simplify, the people who would have been frustrated become advocates. They contribute back. They write about it. They bring it to the next job. A library is most useful when it disappears into the work the developer was actually trying to do. That's the bar. Not how impressive the API is, not how clever the implementation is. How much friction it removed from someone you'll never meet.

Build for that person.
