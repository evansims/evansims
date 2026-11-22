---
title: Developer Experience Isn't a Layer
topic: Developer Experience
updated: 2026-04-29
description: "Five things decide whether developers adopt your product, and all five are settled while you're still building it."
---

It's how you're adopted.

At Auth0 I was an early engineer on the developer experience team, and we shipped more than 45 open source libraries. Since then I've helped teams wire identity and authorization into their products, first on OpenFGA at Okta and now at InferaDB. One thing has held across all of it. Developer experience added after the product is finished reads as what it is, an apology for choices made earlier.

The same five patterns keep showing up.

## Documentation

Docs are where a developer decides whether to keep going. They arrive with a specific problem, and the page either gets them to working code or loses them. So write for the problem they came with, in the words they'd use for it, and put the answer wherever they're working: your site, their editor, the AI tool they're asking.

Docs also have to keep pace with the product. When the docs and the library disagree, the docs are wrong, and they deserve a fix as fast as the code gets one.

## Community

Community takes years to pay back, so the company has to believe in it. It works when you treat the developers in it as collaborators. Someone files a bug and you fix it. Someone opens a pull request and you review it, merge it, and thank them by name.

Developers stay when they can see their report changed something, in the product or in the docs. Find them where they talk, which for most projects means GitHub issues, a Slack or Discord, Reddit, and the occasional meetup. Hold office hours. Send what you hear to the people building the product the same day, and let it move the roadmap.

Two examples from Auth0. At Oktane, Java customers gave us feedback that helped us refine and ship a much better Java SDK. And the major overhaul of the Auth0 PHP SDK, which I led, was shaped and then redefined by what developers told us on GitHub and in the Auth0 Community.

## Education

Teaching is the best marketing a developer product has, short of a customer vouching for you. A lot of my own teaching has been live, on streams and in OpenFGA's community meetings, where a developer can ask the question the written guide skipped.

Good teaching answers three questions: how do I use this, why does it exist, and what can I build with it. Skip "hello world" and demo the real use. When the same question arrives a third time, the answer becomes a guide, a video, or an example repo. Keep both kinds of material, reference docs for looking things up and tutorials or workshops for learning in order.

## APIs

API design *is* developer experience. A great UI cannot save a confusing API, but a great API often survives mediocre UI.

Good APIs are predictable. Naming is consistent enough that developers can guess the next endpoint, field, or option. Errors explain what went wrong and how to fix it, not just an error code. The happy path is the obvious path, with sensible defaults and minimal configuration. Platform conventions are respected instead of fought.

For most products, the API is the real interface developers integrate with. SDKs, CLIs, and UIs are layers on top. If the core API is awkward, every layer inherits that pain.

Design APIs alongside documentation and example code, not in isolation. Watch real developers use your API for the first time and note where they hesitate or guess. Treat breaking changes as a last resort; when you must break, do it with migration guides, codemods, and clear timelines. Invest in consistent pagination, filtering, authentication, and webhooks. Inconsistency in cross-cutting concerns is where DX usually dies.

## Organizations

DX is an organizational *capability*, and no single person can carry it.

If nobody owns DX, it becomes everyone's part-time hobby and then slowly dies. If only one team owns DX, they become a bottleneck. The best orgs treat DX as a partnership between product, engineering, docs, support, and marketing.

Product cares about making the right thing. DX ensures it's the right shape for developers. Engineering builds primitives. DX helps turn them into usable workflows. Docs and education turn features into understanding, not just release notes. Support and success feed real-world friction back into the roadmap.

Give DX a clear owner, or a small team, with real authority, not just advisory power. Make "time to first successful integration" and "support tickets per integration" *real* metrics, not vanity ones. Involve DX early in product design, not just at launch when there are docs to write.

All five get decided while the product is being built. That's why none of them can be added at the end.
