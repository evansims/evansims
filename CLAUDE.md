# evansims.com

Personal site (Jekyll source in `docs/`) and writing portfolio for Evan Sims. Claude Code skills live under `.claude/skills/`.

## Writing style enforcement

Two writing-style skills are the canonical source of style rules for this project:

- `.claude/skills/writing-style-life/` — life, philosophy, productivity, mindfulness, habits, health, general craft.
- `.claude/skills/writing-style-technical/` — software engineering, systems, infrastructure, developer experience, identity/auth, AI/agents.

Both skills auto-invoke when their description matches the user's intent. They can also be invoked explicitly ("use the technical style", "audit this against the life voice", etc.).

### When editing or creating an essay in `docs/`

This means any blog-essay markdown file — not site infrastructure (`_data/`, `_includes/`, `_layouts/`, `_sass/`, `_site/`) and not non-essay pages (`index.md`, `talks.md`, `videos.md`, `podcast.md`, `writing.md`, `resume.pdf`, `feedback.md` if it's the contact page rather than an essay).

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

- The site is built with Jekyll. Source markdown lives in `docs/`; `docs/_site/` is the build output and should not be edited directly.
- `docs/_data/writing.yml` is the index of blog posts shown on the writing page. When the `header:` frontmatter of a post changes, update its `name:` entry in `writing.yml` to match.
- Blog posts use `byline: true` and either `layout: blog` or `layout: default`. Don't add `image:` frontmatter — it was removed across all posts intentionally.
- Two README-style files outside `docs/`: the repo-root `README.md` (GitHub profile README) and this `CLAUDE.md`. Neither is published to the Jekyll site.
