# evansims.com

Personal site (Jekyll source in `docs/`) and writing portfolio for Evan Sims. Claude Code skills live under `.claude/skills/`.

## Writing style enforcement

Two writing-style skills are the canonical source of style rules for this project:

- `.claude/skills/writing-style-life/` — life, philosophy, productivity, mindfulness, habits, health, general craft.
- `.claude/skills/writing-style-technical/` — software engineering, systems, infrastructure, developer experience, identity/auth, AI/agents.

Both skills auto-invoke when their description matches the user's intent. They can also be invoked explicitly ("use the technical style", "audit this against the life voice", etc.).

### When editing or creating an essay in `docs/`

This means any markdown file in `docs/_essays/` — not site infrastructure (`_data/`, `_includes/`, `_layouts/`, `_plugins/`, `_site/`) and not non-essay pages (`index.md`, `talks.md`, `writing.md`, `404.html`, `resume.pdf`).

1. **Classify the post genre.**
   - **Technical** (engineering, systems, identity/auth, AI/agents, code, developer experience) → invoke the `writing-style-technical` skill.
   - **Life / philosophy** (productivity, habits, mindfulness, philosophy, personal reflection, health, general craft) → invoke the `writing-style-life` skill.
   - **Framework guide** (e.g., `docs.md`, `beliefs.md`) → invoke whichever skill matches the dominant subject matter, and apply that skill's framework variant.

2. **Run the skill's drafting checklist** against the result before declaring an edit complete. Apply minimum-viable fixes for clear violations:
   - Em-dashes over budget
   - "It's about…" filler sentences
   - Recycled philosopher or modern-bestseller quotes (Marcus Aurelius / Seneca / Lao Tzu / James Clear / etc.)
   - AI-essay tells ("In our fast-paced world", "It's important to note", "the hustle and bustle", etc.)
   - Numbered listicle headings (`## 1. Foo` → `## Foo`)
   - Missing closing thesis (post that trails off after the last bullet/paragraph)
   - First sentence that's setup rather than a claim

3. **Preserve existing voice and structure** beyond what the rubric requires for a passing grade. Don't unilaterally restructure or rewrite tone unless the user asks. The user has reviewed and approved most of the existing edits one-by-one — preserve those choices.

### Site-specific notes

- The site is built with Jekyll 4 and deployed by GitHub Actions (`.github/workflows/pages.yml`), which runs the test suite before it publishes. Source lives in `docs/`; `docs/_site/` is the build output and should not be edited directly.
- Essays live in `docs/_essays/<slug>.md` and publish at `/<slug>`. One layout, `_layouts/essay.html`, renders all of them.
- Essay frontmatter is `title`, `topic`, and `updated`, plus optional `description` and `lede`:
  - `title` is the on-page headline. The layout appends " — Evan Sims" for the browser tab.
  - `topic` must be one of the values in `docs/_data/topics.yml`.
  - `updated` is required, never displayed, and set by hand. It feeds the Atom feed and the sitemap. Set it to the publish day for a new essay, and change it only when the body changes in a way readers should be told about.
  - `description` defaults to the essay's first paragraph. Write one when the essay opens with a heading or a long paragraph.
  - `lede: false` turns off the large styled first paragraph.
  - Don't add `image:`, `layout:`, `byline:`, or `header:`. They were removed across all essays intentionally.
- `docs/_data/writing.yml` is the curated order of essays, plus the `featured` flags that drive the homepage. Every essay must be listed there by `slug`. Titles and descriptions come from each essay's own frontmatter.
- The build fails, naming the essay, when one is missing from `writing.yml` or listed there twice, uses an unknown topic, or lacks a required field. It also fails when an essay has no `description` and does not open with a plain paragraph of 160 characters or fewer.
- `docs/_plugins/essays.rb` computes each essay's order, reading time, and description. `docs/_plugins/agent_files.rb` writes the `/<slug>.md` copies and `/llms-full.txt`.
- Run the tests after changing layouts, includes, plugins, data, or frontmatter: `cd docs && mise exec -- bundle exec ruby ../test/site_test.rb`. They build the site and assert on the output.
- Styles are one plain CSS file, `docs/assets/css/site.css`. The site makes no third-party requests, and its only JavaScript is the inline theme script in `_includes/theme.html`.
- Files outside `docs/` are not published: the repo-root `README.md` (GitHub profile README), this `CLAUDE.md`, `specs/` (design docs and plans), and `test/`.
