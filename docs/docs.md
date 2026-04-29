---
title: Documentation — Evan Sims
header: Documentation
byline: true
layout: default
---

Documentation has changed. Here's what "great" means now.

## Fast

- Pages should load quickly (prefer static pages).
- Optimize image, font, and script loading.
- Make search feel instant.

## Readable

- Be concise; make every token count.
- Avoid unnecessary jargon and idioms.
- Optimize for skimming with headings, lists, emphasis, and images.
- Keep the first-time experience simple; reveal complexity gradually.
- Include many copy/pasteable and runnable code examples.

## Helpful

- Document workarounds, even when they expose product gaps.
- Make it easy to leave feedback (including typo reports) on every page.
- Automatically check for broken links on each push.
- Offer structured learning paths, not just reference pages.
- For breaking changes, provide migration guides and codemods where possible.

## AI-Native

- Prefer cURL and HTTP examples over click-heavy UI flows.
- Prefer prompts and tasks over long, linear tutorials.
- Add an "Ask AI" helper that can reference your docs.

## Agent Ready

- Make content easy to copy into AI tools as clean Markdown.
- Support viewing pages as Markdown (for example, via a .md URL).
- Serve Markdown when Accept: text/markdown is requested.
- Serve an llms.txt (or similar) that lists your Markdown sources.

## Polished

- Use generous hit areas for buttons and navigation, especially sidebars.
- Preserve sidebar scroll position and expanded state.
- Provide clear hover and active states for interactive elements.
- Generate dynamic OG images for sharing.
- Ensure every heading has a stable, linkable anchor.
- Cross-link related guides, APIs, and examples.
- Add metadata and canonical tags so docs render cleanly in search.

## Localized

- Avoid defaulting to /en in URLs.
- Use server-side routing to serve the correct language.
- Localize both static strings and docs content.

## Responsive

- Provide great mobile navigation and solid Safari iOS support.
- Use tooltips on desktop and popovers on mobile where appropriate.

## Accessible

- Offer a "skip to main content" shortcut.
- Ensure all images have meaningful alt text.
- Respect prefers-reduced-motion and other system settings.

## Universal

- Ship docs-as-code for libraries (for example, via JSDoc output or a package).
- Ship your docs as an MCP (for example, with Context7).
- Include docs with your libraries in node_modules (or equivalent).
- Ship rules files (like AGENTS.md) with your product.
- Provide evals and recommend specific models or setups for your product.

---

Most teams hit four or five of these. The best teams hit all of them.
