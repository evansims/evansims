---
title: Developer Experience (DX) — Evan Sims
header: Developer Experience (DX)
byline: true
layout: default
---

Developer Experience is about building products developers **want** to use, not just can use. Over the past five years I've shipped 50+ open source libraries and helped teams integrate identity and authorization at scale, and the same patterns keep showing up.

DX isn't just a nice-to-have layer on top of your product. It's how your product is discovered, understood, adopted, and recommended.

## 1. Documentation

Docs make or break developer products.

They must be high-quality and available everywhere: on your website, in the editor, and inside AI tools. Your goal is to write content beginners can understand and experts still learn from.

Great docs do three things:

- Show how to solve real problems, not just list APIs.
- Match how developers actually talk and think about their work.
- Stay close to the product as it evolves instead of lagging behind releases.

## 2. Community

Community is a long-term investment, not a short-term acquisition channel. It has to be in your company's DNA.

It's not a list of developers you're trying to sell to. It's an exchange: they share bugs; you fix them. They submit pull requests; you review, merge, and celebrate them.

A real community forms when developers feel heard:

- They share wins and frustrations, and you respond by improving the product or clarifying the docs.
- You meet them where they already are: GitHub, X, Reddit, Slack, conferences, and meetups.
- Their feedback shapes the roadmap, not just the marketing copy

_Suggestions:_

- You can't spend too much time talking to developers in the community.
- Make yourself accessible to answer questions (office hours, AMAs, Discord/Slack).
- Monitor feedback on social media to understand sentiment and spot sharp edges.
- Pipe real-time user feedback into product teams (e.g., Slackbot, dashboards).
- Invest in thoughtful swag for your top community members.
- Everybody loves stickers. They're cheap, fun, and travel further than ads.

## 3. Education

Education is the best form of marketing, second only to customer testimonials.

Good education shows:

- How to use your product.
- Why it exists.
- What developers can realistically accomplish with it.

It's part storytelling, part technical guide, part product demo.

_Suggestions:_

- Build demos that show real-world usage of your product, not just "hello world."
- If you answer the same question more than twice, turn it into a guide, video, or example repo.
- Provide both reference material (docs) and structured learning paths (tutorials, courses, workshops).

## 4. APIs

API design _is_ developer experience. A great UI cannot save a confusing API, but a great API often survives mediocre UI.

Good APIs do a few things consistently:

- Use predictable, consistent naming so developers can guess the next endpoint, field, or option.
- Return helpful errors that explain what went wrong and how to fix it, not just an error code.
- Make the happy path the obvious path, with sensible defaults and minimal configuration.
- Respect HTTP (or the platform's) conventions instead of fighting them.

For most products, the API is the real interface developers integrate with. SDKs, CLIs, and UIs are layers on top. If the core API is awkward, every layer inherits that pain.

_Suggestions:_

- Design APIs alongside documentation and example code, not in isolation.
- Watch real developers use your API for the first time and note where they hesitate or guess.
- Treat breaking changes as a last resort; if you must break, do it with migration guides, codemods, and clear timelines.
- Invest in consistent pagination, filtering, authentication, and webhooks; inconsistency in cross-cutting concerns is where DX often dies.

## 5. Organizations

DX is not a single person's job. It's an organizational capability.

If nobody owns DX, it becomes everyone's part-time hobby and then slowly dies. If only one team owns DX, they become a bottleneck. The best orgs treat DX as a partnership between product, engineering, docs, support, and marketing.

Healthy DX org patterns:

- Product cares about making the right thing. DX ensures it's the right shape for developers.
- Engineering builds primitives. DX helps turn them into usable workflows and abstractions.
- Docs and education turn features into understanding, not just release notes.
- Support and success feed real-world friction back into the roadmap.

_Suggestions:_

- Give DX a clear owner (or small team) with real authority, not just advisory power.
- Make "time to first successful integration" and "number of support tickets per integration" key metrics.
- Involve DX early in product design, not just at launch time to "write the docs."
- Celebrate DX wins internally: a smoother onboarding flow, fewer support tickets, a glowing community post.
