---
title: Hire Product Engineers, Not Fullstack
topic: Teams
updated: 2026-04-29
description: "Why I hire for how close an engineer gets to the outcome, and what that looks like for SDKs and authorization services."
---

Stack is the wrong axis.

"Frontend" and "backend" have stopped describing how software gets built. The engineers I'd hire work backwards from the experience to whatever technology delivers it, and they care more about the outcome than about which half of the stack they sit in. This isn't only about web apps. I've spent my career a layer or two below the web tier, and it holds there too.

At Auth0 the product I shipped was an SDK. My user was another engineer, and the experience was their first ninety seconds with a README and an error message. On OpenFGA, and now at InferaDB, the product is an authorization service. The users are the developers who call it and the operators who get paged when it's slow. Nobody would call any of that frontend, and all of it is product work.

Three traits mark a product engineer, whatever the layer. They're *iterative*, which means shipping something small, hearing from the people who use it, and adjusting. They're *customer focused*, and for infrastructure the customer is a developer or an operator they can go and talk to. They're *pragmatic* about tools. The newest database or queue is worth nothing if nobody uses what you built with it.

What changes most below the web tier is the meaning of finished. A product engineer on a service has thought about retries, limits, and partial failure, and about how the system behaves under load and during an incident. In an interview, ask to be walked through one thing they built end to end, whether that's a feature, an SDK, or a service. Listen for the fundamentals, like HTTP, queues, data stores, and distributed systems. Framework names tell you much less.

Product engineers need something to stand on. Platform engineers build or buy it: identity, authorization, observability, CI/CD, environments. They make the big infrastructure decisions once so every product team can move fast without getting hurt.

A platform function used to be something only large companies had. A small team gets value from one sooner than you'd expect, usually around the point where every product engineer is solving the same infrastructure problem separately. I build one of those shared pieces for a living, so weigh my opinion accordingly.

Hire for how close someone gets to the outcome. Their place in the stack only tells you where they started.
