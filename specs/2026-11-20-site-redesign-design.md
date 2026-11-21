# evansims.com redesign and GitHub profile README

Design doc, 2026-11-20. Status: reviewed, awaiting Evan's approval.

## Intent

Rebuild evansims.com from the ground up so that someone vetting Evan (an investor, a candidate, a customer, a peer) understands who he is within one screen, finds the proof in his writing, and has an obvious way to reach him. Make the same content easy for AI agents to read and cite. Rewrite the GitHub profile README from the same positioning.

## Goals

1. A visitor who has never heard of Evan can state his role and track record after one screen of the homepage.
2. Essays are the best reading experience on the site, at every width from 320px up, in light and dark.
3. An agent can discover, fetch, and cite every essay without parsing HTML.
4. The site looks deliberate and distinct from the common dark, monospace developer portfolio.
5. Production builds with the same toolchain as local.

## Non-goals

- No change to essay prose. Only frontmatter changes.
- No analytics, comments, search, newsletter signup, or CMS.
- No MCP endpoint and no content negotiation (`Accept: text/markdown`). Static hosting cannot do either.
- No per-essay share images in this pass. One site-wide share card ships now.
- No visible publish dates. Essays stay undated and in curated order.

## Anti-goals

- A site that reads as a template or as AI-generated.
- Any third-party request at page load (fonts, embeds, scripts, images).
- Content that requires JavaScript to read.
- Broken or changed essay URLs.

## Constraints

- Jekyll source lives in `docs/`. `docs/_site/` is build output.
- Custom domain `evansims.com` on GitHub Pages, currently the legacy branch build from `main:/docs`.
- Local toolchain: Ruby 4.0.1 via mise, Bundler 4.0.6, Jekyll 4.4.1. The site builds locally today (with a Sass `@import` deprecation warning).
- 33 essays exist as root-level pages in `docs/`. Their URLs are extensionless (`/both-directions-kill-you`) and must not change.
- `CLAUDE.md` style rules apply to essay prose. This project does not touch prose, so the writing-style skills are not triggered by the frontmatter migration.

## Approaches

### Design direction

Three directions were mocked up with real content and compared at desktop and phone widths in both themes.

- **A, Editorial.** Serif type, paper tones, a typeset record, essays as the proof. Gains: essays look their best and the site is unlike most engineers' sites. Costs: says "writer" a beat before "CTO".
- **B, Dossier.** Fixed identity rail, numbered sections, mono labels. Gains: fastest route to credibility. Costs: the familiar dev-tool look; essays read as entries.
- **C, Statement.** One conviction at poster scale, then proof cards. Gains: strongest first five seconds. Costs: loudest, likeliest to date.

**Evan picked A.** The record sits directly under the hero to offset A's cost.

Visual reference: direction A in `.superpowers/brainstorm/4183-1795234012/content/directions.html` (the `a-css`, `a-home`, and `a-essay` blocks). That file is local and untracked. Treat it as the look to match, not as code to copy.

### Build

- **1. Jekyll with a GitHub Actions build.** Production matches local Jekyll 4.4. Custom plugins are allowed, which makes per-essay Markdown copies possible. Cost: one Pages setting change and one workflow.
- **2. Jekyll on the legacy build.** No deploy change. Stuck on Jekyll 3.10 and the plugin allowlist; no per-essay Markdown copies.
- **3. Move to Astro.** Best tooling for endpoints and share images. Largest change for a 40-page static site.

**Evan picked 1.**

## Decided by Evan

- Primary audience: people vetting him. Desired action: read an essay, then get in touch.
- Design direction A.
- Jekyll with an Actions build.
- Essays stay undated.
- Each essay has one title: today's on-page headline (`header`). The 24 older browser-tab titles that differ from it are dropped.

Everything below is Claude's proposal unless it restates one of those five.

## Information architecture

| URL | Page | Notes |
|---|---|---|
| `/` | Home | Position, record, selected writing, elsewhere, contact |
| `/writing` | Writing index | All 33 essays in two groups |
| `/<slug>` | Essay | 33 pages, URLs unchanged |
| `/talks` | Talks | Five talks as a typeset list linking to YouTube |
| `/404.html` | Not found | Links to Home and Writing |
| `/resume.pdf` | Résumé | Unchanged file |

Removed: `/videos` and `/podcast`. Both are empty today. The homepage's podcast link goes with them.

Primary nav: Writing, Talks, Contact (mailto), and a theme toggle. The name in the masthead links home.

## Visual system

### Color

Tokens are CSS custom properties. Light is the default look; dark is a first-class peer.

| Token | Light | Dark | Use |
|---|---|---|---|
| `--paper` | `#f5f1e8` | `#13120f` | Page background |
| `--ink` | `#1c1a16` | `#ece6d9` | Primary text |
| `--soft` | `#4a463d` | `#c4bdae` | Secondary text |
| `--muted` | `#6b6558` | `#8f8878` | Labels, metadata |
| `--rule` | `#d8d1c1` | `#2d2a24` | Hairlines |
| `--accent` | `#b23a1c` | `#e8805c` | Labels, lede, hover, emphasis in the hero |

Every text and background pair must meet WCAG AA (4.5:1 for body and label text). The mockup's light `--muted` was about 4.1:1; the value above corrects it.

Theme follows `prefers-color-scheme`. A toggle in the nav overrides it and persists in `localStorage`. A small inline script in `<head>` applies the stored choice before first paint. This is the only JavaScript on the site.

### Type

- **Newsreader** (variable, roman and italic, Latin subset, self-hosted WOFF2, SIL OFL) for headlines, body, and essay text.
- **Labels and small UI text:** the system sans stack (`system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`). This replaces Inter and removes the 352 KB `InterVariable.woff2`. See "Calls to check" for the alternatives.
- Fluid sizes with `clamp()`. Reference values from the mockup: hero headline `clamp(2.3rem, 6.2vw, 4.5rem)` at line-height 1.04; essay title `clamp(2.5rem, 8vw, 4.5rem)`; essay body `clamp(1.19rem, 1.6vw, 1.3125rem)` at line-height 1.62; labels `0.72rem`, uppercase, `0.14em` tracking.
- Essay measure: 41rem maximum.
- `text-wrap: balance` on headlines, `text-wrap: pretty` on body where supported.

### Layout

- Page container: 70rem maximum, side padding `clamp(1.25rem, 5vw, 3.5rem)`.
- Sections separated by 1px rules in `--rule`, with vertical rhythm from `clamp()` values in the mockup.
- One breakpoint family around 720px where multi-column rows stack. No horizontal scroll at 320px.

### Motion

Color transitions on hover only, 150ms. Cross-document view transitions (`@view-transition { navigation: auto; }`) as progressive enhancement. All motion is disabled under `prefers-reduced-motion: reduce`.

## Page designs

### Home

In order:

1. **Masthead.** Name left, nav right, rule below.
2. **Hero.** Accent label, headline, one lead paragraph, two text links ("Read the writing", "Get in touch").
3. **Record.** Four rows: when, organization with role beneath, one or two sentences. A "Résumé (PDF)" link sits in the section header. Rows come from `_data/record.yml`.
4. **Selected writing.** The essays marked `featured` in `_data/writing.yml`, as a numbered list: number, title, description in italic, and "Topic · N min" on the right. An "All 33 essays" link in the section header (the count is computed).
5. **Elsewhere.** Three short blocks: Speaking, Advising, For agents.
6. **Personal line.** One sentence about life outside work.
7. **Footer.** Email address as a large italic link, then social links, RSS, `/llms.txt`, and the copyright line with a computed year.

On phones every multi-column row stacks, and the essay metadata drops beneath the description.

### Essay

1. Masthead (same as Home).
2. Meta row: topic in accent, reading time, and a "Markdown" link to the `.md` copy.
3. Title.
4. Prose. The first paragraph is styled as a lede (larger, italic, accent) when it is a single short line, which is how 31 of the 33 essays open. An essay opts out with `lede: false`. "The Wisdom Tax" opts out because its first paragraph is long. "Things I Believe" opens with a heading, so the rule does not match.
5. Byline card: headshot, name, one-sentence bio.
6. Next essay (the next one in curated order, wrapping at the end) and a link back to the index.
7. Footer (same as Home).

Prose styles must cover every element that appears in the 33 essays: `h2`, `h3`, lists, blockquotes, `hr`, links, emphasis, strong, and anything else an audit of the files turns up (code, tables, images).

Essays print cleanly: nav, byline card, next links, and footer are hidden in print; text is black on white.

### Writing index

Two groups under headings, **Engineering** then **Life & craft**. Each group uses the same list component as the homepage. Within a group, essays keep the order they have in `_data/writing.yml`.

### Talks

A typeset list, no iframes and no thumbnails. Each row: title, host, and a "Watch on YouTube" link. Data in `_data/talks.yml`:

| YouTube ID | Title | Host |
|---|---|---|
| `9j-LLLTvW34` | Coffee & Code | Carla Stabile |
| `3M_gu53m2_g` | OpenFGA Community Meeting, April 2025 | OpenFGA |
| `KmRr1Fz_6Zo` | OpenFGA Community Meeting, February 2025 | OpenFGA |
| `KK16e8EPuDU` | OpenFGA Community Meeting, August 2024 | OpenFGA |
| `I1vhuWceQ3s` | OpenFGA MCP Demo | OpenFGA |

Titles came from YouTube's oEmbed endpoint on 2026-11-20.

### 404

Masthead, a one-line message, links to Home and Writing, footer.

## Content model

### Essays become a collection

The 33 essay files move from `docs/*.md` to `docs/_essays/*.md`, with `permalink: /:name` so every URL stays the same. Use `git mv` so history follows.

Collection defaults in `_config.yml` set the layout, so essay frontmatter shrinks to:

```yaml
---
title: "Both Directions Kill You"
topic: Life
updated: 2026-04-29
---
```

- `title` takes the value of today's `header` field on every essay. The layout builds `<title>` as "Title — Evan Sims", and the same string feeds the headline, Open Graph title, feed, and `llms.txt`. Today's `title` values are discarded; on 24 essays they differ from `header` (for example "Thoughtful Design" becomes "You Can Tell").
- `topic` is one value from the vocabulary below.
- `description` is optional. When absent, the layout uses the essay's first paragraph. Two essays need an explicit one (see "Copy for approval").
- `lede: false` is optional (see Essay above).
- `updated` is required and never displayed. It is a frozen date used only by the feed and the sitemap. The migration seeds it with the date of each essay's last commit before this project: 2026-11-20 for `the-interface-is-the-speed-limit`, 2026-04-29 for the other 32. Evan changes it by hand only when an essay's body changes in a way readers should be told about. A new essay sets it once, to the day it is published. The build fails with a clear message if an essay lacks it.
- `byline`, `layout`, and `header` are removed from essay frontmatter.

### Topics

Fixed vocabulary, mapped to the two index groups in `_data/topics.yml`.

- **Engineering:** Systems, AI, Developer Experience, DevRel, Product, Teams, Principles
- **Life & craft:** Life, Craft, Health

Proposed assignment (Evan to correct):

| Essay (slug) | Topic |
|---|---|
| the-interface-is-the-speed-limit | Systems |
| agentic-engineering | AI |
| how-ai-knows-what-youll-say-next | AI |
| developer-experience | Developer Experience |
| docs | Developer Experience |
| the-art-of-building-open-source-libraries | Developer Experience |
| developer-marketing | DevRel |
| developer-relations | DevRel |
| community-moderation | DevRel |
| feedback | DevRel |
| developer-products | Product |
| product-engineering | Teams |
| beliefs | Principles |
| prune-to-prosper | Craft |
| clarity-and-connection | Craft |
| thoughtful-design | Craft |
| stay-in-motion | Craft |
| finding-the-right-problem | Craft |
| optimizing-health-my-daily-supplement-regimen-for-energy-longevity-and-well-being | Health |
| both-directions-kill-you | Life |
| downtime-as-self-care | Life |
| cultivate-a-more-optimistic-future | Life |
| tiny-changes | Life |
| embrace-calm-amidst-chaos | Life |
| better-living-through-compromise | Life |
| hanlons-razor | Life |
| the-price-of-convenience | Life |
| mend-what-matters | Life |
| identity-follows-action | Life |
| relax-nothing-matters | Life |
| the-cost-of-every-movement | Life |
| the-productivity-heist | Life |
| the-wisdom-tax | Life |

### Data files

- `_data/writing.yml` stays as the single curated order, reduced to `slug` and `featured`. Titles, topics, and descriptions come from each essay's own frontmatter, so the rule "update `name:` when `header:` changes" disappears. Featured flags carry over unchanged.
- `_data/record.yml`: the four record rows.
- `_data/talks.yml`: the five talks.
- `_data/topics.yml`: topic to group mapping.
- `_data/socials.yml`: unchanged.
- `_data/metadata.yml`: removed. Author and site values move to `_config.yml`; the copyright year is computed.

Reading time is computed in the layout: words divided by 230, rounded up, minimum 1.

## Agent surface

1. **Markdown copy of every essay** at `/<slug>.md`: an `# H1` title, the essay's raw Markdown body, and a source line with the canonical URL. The description is added as a blockquote under the title only when it is explicit in frontmatter; when it is derived from the first paragraph it would print the same line twice. Emitted by a small custom Jekyll plugin in `docs/_plugins/`. The essay page links to it visibly in the meta row and with `<link rel="alternate" type="text/markdown">`.
2. **`/llms.txt`** in the llmstxt.org shape: `# Evan Sims`, a blockquote summary, a short paragraph with the record, then `## Engineering` and `## Life & craft` link lists pointing at the `.md` copies with each essay's description, then `## Elsewhere` (talks, résumé, contact).
3. **`/llms-full.txt`**: every essay's Markdown concatenated in curated order.
4. **`/feed.xml`**: Atom, full content, all essays. Each entry's `updated` comes from the essay's `updated` frontmatter, never from build time or git, so a deploy or a frontmatter-only commit does not make feed readers show old essays as new.
5. **`/sitemap.xml`** and **`/robots.txt`**. Sitemap `lastmod` for essays uses the `updated` field. Robots allows all crawlers, AI crawlers included, and names the sitemap.
6. **JSON-LD.** Home: `Person` (name, url, image, jobTitle, worksFor InferaDB, sameAs for each social profile) and `WebSite`. Essays: `BlogPosting` (headline, description, author, url, wordCount, articleSection from topic). Essay JSON-LD carries no dates, because search engines show `dateModified` and `datePublished` to people and the essays are undated.
7. **Semantic HTML.** One `main`, `article` for essays, labeled `nav` elements, correct heading order in everything the templates produce, `lang="en"`. Everything is readable with CSS and JavaScript off. Known exception: the supplement essay's own headings skip levels (`####` before `##`). Prose is not touched in this project, so that stays as written.

## Head and metadata

Every page gets: `<html lang="en">`, a unique `<title>`, a meta description, a canonical URL, Open Graph and Twitter card tags, `theme-color` for both schemes, the feed autodiscovery link, and the icon links. Footer social links keep `rel="me"`.

- Share image: one 1200×630 card in the direction A style (paper background, name, position line), committed as a static PNG and used site-wide.
- `site.webmanifest` gets a real name ("Evan Sims") and colors that match the tokens.
- `_config.yml` gains `url: https://evansims.com`, `title`, `description`, the collection and its defaults, an `exclude` list, and compressed CSS output.

## Accessibility and performance

- WCAG 2.2 AA: contrast as above, visible focus styles, a skip link, touch targets of at least 44px in the nav, no information carried by color alone.
- Budgets: no third-party requests; one stylesheet under 20 KB uncompressed; JavaScript limited to the inline theme script; two font files (Newsreader roman and italic), with the roman preloaded and `font-display: swap`.
- Headshot for the byline card derived from `android-chrome-512x512.png` at 96px and 192px in a modern format.
- Favicons recompressed. `android-chrome-512x512.png` is 460 KB today.

## Build and deploy

- `.github/workflows/pages.yml`: on push to `main` and on manual dispatch. Check out, set up Ruby with Bundler caching in `docs/`, run `bundle exec jekyll build` with `JEKYLL_ENV=production`, upload `docs/_site` as the Pages artifact, deploy with the official Pages actions.
- `Gemfile` pins `jekyll ~> 4.4`. `Gemfile.lock` gains the `x86_64-linux` platform.
- Stylesheets: no Sass deprecation warnings. Plain CSS or Sass with `@use` are both acceptable.
- Work happens on a `redesign` branch and lands through a pull request. Nothing is pushed without Evan's say.
- **Cutover order.** Evan (or Claude with Evan's explicit yes at that moment) switches the Pages source to "GitHub Actions" first. The live site keeps serving the last legacy deployment until a workflow deploys. Then the pull request merges and the workflow publishes the new site. Rollback is reverting the squash commit and switching the source back to `main:/docs`. (The repo allows squash and rebase merges only.)

## Cleanup

Delete:

- `docs/assets/images/blog/` (21 files, 5.5 MB). No essay references them.
- `docs/videos.md`, `docs/podcast.md`.
- `docs/_layouts/blog.html` (merged into one essay layout), `docs/_includes/featured.html`, `writing.html`, `youtube.html` (replaced).
- `docs/assets/fonts/InterVariable.woff2`, if the system-sans call stands.
- `docs/_data/metadata.yml`, `.gitkeep` files in directories that now have content.

## README

The GitHub profile README is rewritten from the same positioning: who, record, writing, contact. It drops the Rust block and the long paragraphs. The draft is under "Copy for approval".

## CLAUDE.md

Update the site-specific notes to match: essays live in `docs/_essays/`; `writing.yml` holds order and featured flags only; essay frontmatter is `title`, `topic`, `updated`, and optional `description` and `lede`; one essay layout; the Actions build. The writing-style rules are unchanged.

## Copy for approval

All of this is draft. Evan approves or rewrites each line.

**Hero**

- Label: Co-founder & CTO, InferaDB
- Headline: Authorization, developer experience, and the *people on the other end* of the software.
- Lead: I'm Evan. I build InferaDB, the authorization database. Before that I was a founding engineer on OpenFGA at Okta, and an early engineer on Auth0's developer experience team.

The current "Howdy! Evan here. 👋" greeting is dropped.

**Record**

- Now · InferaDB · Co-founder & CTO. The authorization database. Zanzibar-inspired, AuthZEN-compliant, and built for fine-grained access control across services, APIs, and AI agents.
- Previously · OpenFGA at Okta · Founding engineer. One of the first Zanzibar-inspired ReBAC systems to market, alongside the Auth0 FGA service built on it. Now a CNCF incubating project used by Grafana Labs, Docker, and Canonical.
- Before that · Auth0 · Developer experience. An early engineer on the developer experience team. Shipped 45+ open source libraries used by enterprise customers.
- Earlier · Ushahidi · Crisis-response tools. Deployed at the United Nations and during the Fukushima disaster response. It taught me to take security, privacy, and the people on the other end of the software seriously.

**Elsewhere**

- Speaking: Talks, demos, and community meetings on authorization and developer experience.
- Advising: I occasionally advise companies. Reach out if you'd like to collaborate.
- For agents: Every essay is also plain Markdown, indexed at /llms.txt, with a full-text feed.

**Personal line** (existing copy, unchanged): When I'm not working, I'm usually reading history and philosophy, exploring longevity and biohacking, or getting lost in music.

**Byline bio:** Evan Sims is co-founder and CTO at InferaDB, the authorization database. Previously a founding engineer on OpenFGA at Okta.

**Home meta description and llms.txt summary:** Evan Sims is co-founder and CTO at InferaDB, the authorization database. He writes about authorization, developer experience, and the craft of building software.

**Explicit essay descriptions**

- Things I Believe: What I hold to about people, building, security, systems, teams, developer experience, and growth.
- The Wisdom Tax: The years spent learning lessons the hard way. Most of it is avoidable.

**README**

```markdown
### Evan Sims

Co-founder and CTO at [InferaDB](https://inferadb.com), the authorization database. I build authorization systems and the developer experience around them.

- **Now:** building [InferaDB](https://inferadb.com). Zanzibar-inspired, AuthZEN-compliant, fine-grained access control for services, APIs, and AI agents.
- **Before:** founding engineer on [OpenFGA](https://openfga.dev) at Okta, now a CNCF incubating project used by Grafana Labs, Docker, and Canonical.
- **Before that:** developer experience at [Auth0](https://auth0.com), where I shipped 45+ open source libraries.
- **Earlier:** crisis-response tools at [Ushahidi](https://www.ushahidi.com), deployed at the United Nations and during the Fukushima disaster response.

**Recent writing**

- [The Interface Is the Speed Limit](https://evansims.com/the-interface-is-the-speed-limit)
- [Agentic Engineering Isn't Vibe Coding](https://evansims.com/agentic-engineering)
- [Developer Experience Isn't a Layer](https://evansims.com/developer-experience)

> Make the right path obvious. Build for the people on the other end. Leave it better than you found it.

[evansims.com](https://evansims.com) · [LinkedIn](https://www.linkedin.com/in/evansims/) · [Bluesky](https://bsky.app/profile/evansims.com) · [X](https://x.com/evansims)
```

## Calls to check

Claude made these. Each is easy to reverse before the build starts.

1. **Labels use the system sans, and Inter is removed.** Alternatives: keep Inter (subset it; it is the font the site uses today), or self-host a more distinctive sans. The system stack costs zero bytes and the serif carries the personality.
2. **Essays move into a `_essays` collection.** Alternative: leave them as root pages and join against `writing.yml` in templates. The collection gives clean iteration for the feed, sitemap, and llms.txt, and shrinks frontmatter.
3. **`writing.yml` keeps order and featured flags only.**
4. **Writing index is grouped into Engineering and Life & craft**, with the topic assignments above.
5. **Talks are a text list with no thumbnails or embeds.**
6. **`/videos` and `/podcast` are removed** with no redirect.
7. **The headshot appears in the essay byline card only.** The hero stays typographic.
8. **One site-wide share image.** Per-essay images are deferred.
9. **Robots allows all AI crawlers,** training crawlers included.
10. **A theme toggle exists,** which makes it the site's only JavaScript. Alternative: follow the system setting only and ship zero JavaScript.
11. **The "Howdy!" greeting is dropped.**
12. **The design doc lives in `specs/` at the repo root** so Jekyll does not publish it.
13. **Every essay carries a hidden `updated` date** for the feed and sitemap. It is one more field to set when publishing. The alternative, reading dates from git, would mark all 33 essays as changed the day this redesign merges and again on any frontmatter edit.
14. **Essay JSON-LD has no dates,** so search results do not attach a date to undated essays.

## Left to the builder

- Exact markup, class names, and file layout for layouts and includes.
- How the Markdown-copy plugin is written (generator or post-write hook).
- Sitemap by plugin or by template.
- Plain CSS or Sass.
- Where to source the Newsreader files and how to subset them. Downloading the font files needs Evan's yes.
- How the share image PNG is produced.
- Image format and exact sizes for the headshot and icons.

## Verification

Done means all of these hold:

1. `bundle exec jekyll build` in `docs/` finishes with no warnings.
2. All 33 essay URLs resolve at their current paths, and each has a `.md` copy.
3. `/llms.txt`, `/llms-full.txt`, `/feed.xml`, `/sitemap.xml`, `/robots.txt`, and `/404.html` exist and are well formed. The feed validates as Atom. JSON-LD parses.
4. Home, an essay, Writing, and Talks are checked in a browser at 320, 390, 768, 1280, and 1920px, in light and dark, with no horizontal scroll and no overlapping text.
5. Pages read correctly with JavaScript disabled and with CSS disabled.
6. Network panel shows zero third-party requests.
7. Contrast and keyboard navigation checked; an automated accessibility scan reports no violations on Home and an essay.
8. Building twice produces a byte-identical `feed.xml`, and a build with an essay missing `updated` fails.
9. Essay prose is byte-identical before and after the migration (frontmatter aside), and every essay's `title` equals its pre-migration `header`.
