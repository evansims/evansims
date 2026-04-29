---
title: Developer Experience (DX) — Evan Sims
header: Developer Experience Isn't a Layer
byline: true
layout: default
---

It's how you're adopted.

Developer Experience isn't a *layer* you bolt onto a finished product. It's how the product is discovered, understood, adopted, and recommended. Bolted-on DX feels exactly like what it is: an apology for choices made earlier.

Over the past five years I've shipped 50+ open source libraries and helped teams integrate identity and authorization at scale. The same patterns keep showing up. Five of them.

## Documentation

Docs make or break developer products.

They have to be high-quality and available everywhere: on your website, in the editor, and inside AI tools. Beginners need to understand them. Experts need to keep learning from them.

Great docs do three things. They show how to solve real problems, not just list APIs. They match how developers actually talk and think about their work. They stay close to the product as it evolves, instead of lagging behind releases.

## Community

Community is a long-term investment, not a short-term acquisition channel. It has to be in your company's DNA.

It's not a list of developers you're selling to. It's an exchange: they share bugs, you fix them. They submit pull requests, you review, merge, and celebrate them.

A real community forms when developers feel heard. They share wins and frustrations; you respond by improving the product or clarifying the docs. You meet them where they already are: GitHub, X, Reddit, Slack, conferences, meetups. Their feedback shapes the roadmap, not just the marketing copy.

You can't spend too much time talking to developers in the community. Hold office hours and AMAs. Monitor sentiment on social, and pipe real-time feedback into product teams. Invest in thoughtful swag for top community members. And ship stickers. Everybody loves stickers. They travel further than ads.

## Education

Education is the best form of marketing, second only to customer testimonials.

Good education shows three things: how to use your product, why it exists, and what developers can realistically accomplish with it. Part storytelling, part technical guide, part product demo.

Build demos that show real-world usage, not "hello world." If you answer the same question more than twice, turn it into a guide, video, or example repo. Provide reference material like docs, and structured learning paths like tutorials, courses, and workshops.

## APIs

API design *is* developer experience. A great UI cannot save a confusing API, but a great API often survives mediocre UI.

Good APIs are predictable. Naming is consistent enough that developers can guess the next endpoint, field, or option. Errors explain what went wrong and how to fix it, not just an error code. The happy path is the obvious path, with sensible defaults and minimal configuration. Platform conventions are respected instead of fought.

For most products, the API is the real interface developers integrate with. SDKs, CLIs, and UIs are layers on top. If the core API is awkward, every layer inherits that pain.

Design APIs alongside documentation and example code, not in isolation. Watch real developers use your API for the first time and note where they hesitate or guess. Treat breaking changes as a last resort; when you must break, do it with migration guides, codemods, and clear timelines. Invest in consistent pagination, filtering, authentication, and webhooks. Inconsistency in cross-cutting concerns is where DX usually dies.

## Organizations

DX is not a single person's job. It's an organizational *capability*.

If nobody owns DX, it becomes everyone's part-time hobby and then slowly dies. If only one team owns DX, they become a bottleneck. The best orgs treat DX as a partnership between product, engineering, docs, support, and marketing.

Product cares about making the right thing. DX ensures it's the right shape for developers. Engineering builds primitives. DX helps turn them into usable workflows. Docs and education turn features into understanding, not just release notes. Support and success feed real-world friction back into the roadmap.

Give DX a clear owner, or a small team, with real authority, not just advisory power. Make "time to first successful integration" and "support tickets per integration" *real* metrics, not vanity ones. Involve DX early in product design, not just at launch when there are docs to write.

DX isn't something you do once you've shipped. It's the shape the product had before you shipped, the conversations you held while you were building, the surface that decided whether anyone stayed.
