---
title: Documentation
topic: Developer Experience
updated: 2026-04-29
---

Documentation has changed. Here's what "great" means now.

The old standards still hold. Pages load fast, the language is plain, and the examples run. What's new is the reader. An agent is reading your docs on a developer's behalf, and it needs different things than the developer does.

Take a developer who asks their coding agent how to check a permission with your SDK. The agent fetches your page. If it gets clean Markdown, it can quote you word for word. If it gets a JavaScript shell behind a cookie banner, it guesses, and the developer blames your product for the wrong answer.

I built this site to that standard. Every essay has a Markdown copy at the same address with `.md` on the end. `/llms.txt` lists them, and `/llms-full.txt` holds all of them in one file. The pages are static and load nothing from third parties, so one fetch returns the whole essay.

For a library I go a step further. I wrote an MCP server for OpenFGA so an agent can query and manage an authorization store itself.

The same four moves apply to any product's docs:

- Serve every page as Markdown at a predictable URL.
- Publish an `llms.txt` that lists those URLs.
- Put a runnable request, cURL or plain HTTP, ahead of any dashboard screenshot.
- Ship the docs inside the package, so the version an agent reads matches the version installed.

The docs still have to work for a person. Now the same page has to work for the agent that person sent.
