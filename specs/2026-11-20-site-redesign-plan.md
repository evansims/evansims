# evansims.com Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild evansims.com in the approved Editorial direction with an agent-readable surface, move it to an Actions build, and rewrite the GitHub profile README.

**Architecture:** Essays become a Jekyll collection whose content model (order, reading time, description, section, validation) is computed by one plugin, so templates only present data. A second plugin writes Markdown copies after the build. Everything else is Liquid templates, one plain CSS file, and a Minitest suite that builds the site and asserts on the output; the same suite gates the deploy workflow.

**Tech Stack:** Jekyll 4.4, Ruby 4.0 (mise), Liquid, plain CSS, Minitest, GitHub Actions and Pages.

**Spec:** `specs/2026-11-20-site-redesign-design.md`. Read it first. Copy, color values, the topic table, and the talks table live there and are not repeated here.

## Global Constraints

- Essay prose is byte-identical before and after. Only frontmatter changes.
- Essay URLs stay extensionless and unchanged: `/<slug>`.
- No third-party request at page load: no remote fonts, scripts, images, or iframes.
- All content is readable with JavaScript off. The only JavaScript is the inline theme script.
- Every text and background pair meets WCAG AA, 4.5:1. Color tokens are exactly the table in the spec.
- One stylesheet under 20 KB uncompressed. Two font files.
- `bundle exec jekyll build` prints no warnings.
- Copy is exactly what the spec's "Copy for approval" section says.
- Visible titles and descriptions pass through Liquid's `smartify` so apostrophes and quotes are typographic. Machine formats (meta tags, JSON-LD, feed, `llms.txt`, Markdown copies) use the raw string, escaped for that format.
- No code comments in any file (Evan's standing rule).
- Work on branch `redesign`. Commit per task with the repo's `feat:` / `docs:` prefixes and no attribution lines. Push nothing without Evan's say.
- Run Ruby commands from `docs/` through mise: `cd docs && mise exec -- bundle exec …`.
- Three steps need Evan's explicit yes when reached: downloading the font files (Task 2), pushing and opening the pull request (Task 8), switching the Pages source (Task 8).

## Review Focus

1. A new essay is added to `_essays/` but not to `writing.yml`, or a slug in `writing.yml` has no file. Expected: the build fails and names the slug. (Task 1)
2. An essay's `topic` is misspelled or outside the vocabulary. Expected: the build fails and names the essay and the topic. (Task 1)
3. An essay's first paragraph contains Markdown (emphasis, a link), or the essay opens with a heading and has no `description`. Expected: derived descriptions are plain text; the heading case fails the build and asks for a `description`. (Task 1)
4. Titles and descriptions contain quotes, apostrophes, or ampersands ("Don't Defend. Explain.", `Here's what "great" means now.`, "Coffee & Code"). Expected: valid HTML attributes, valid JSON-LD, valid Atom. (Tasks 2 and 5)
5. A long title, a long slug, or dense structure on a 320px screen (the supplement essay, "Agentic Engineering Isn't Vibe Coding"). Expected: no horizontal scroll and no clipped text. (Task 3)

---

## File Structure

```
.github/workflows/pages.yml      build, test, deploy
test/site_test.rb                builds the site, asserts on output
README.md                        profile README (rewritten)
CLAUDE.md                        site notes (updated)
docs/
  _config.yml                    site values, collection, defaults
  _plugins/essays.rb             content model: validate, enrich, order
  _plugins/agent_files.rb        writes <slug>.md and llms-full.txt after build
  _data/writing.yml              curated order: slug, featured
  _data/topics.yml               topic vocabulary and groups
  _data/record.yml               four record rows
  _data/talks.yml                five talks
  _data/socials.yml              unchanged
  _essays/<slug>.md              33 essays
  _layouts/default.html          page shell
  _layouts/home.html
  _layouts/essay.html
  _layouts/page.html             Writing, Talks, 404
  _includes/head.html            title, meta, Open Graph, icons, JSON-LD hooks
  _includes/theme.html           inline theme script
  _includes/masthead.html
  _includes/footer.html
  _includes/essay-list.html      numbered essay list (Home, Writing)
  _includes/byline.html
  _includes/jsonld-person.html
  _includes/jsonld-essay.html
  _og/card.html                  source for the share image (not published)
  assets/css/site.css
  assets/fonts/newsreader-latin-roman.woff2
  assets/fonts/newsreader-latin-italic.woff2
  assets/fonts/OFL-Newsreader.txt
  assets/images/evan.jpg         192px headshot
  assets/og.png                  1200x630 share card
  index.md  writing.md  talks.md  404.html
  llms.txt  feed.xml  sitemap.xml  robots.txt
```

---

### Task 1: Branch, test harness, and essay content model

**Files:**
- Create: `test/site_test.rb`, `docs/_plugins/essays.rb`, `docs/_data/topics.yml`, `docs/_layouts/essay.html` (bare; Task 3 replaces it)
- Move: `docs/<slug>.md` to `docs/_essays/<slug>.md` for the 33 slugs in `docs/_data/writing.yml`
- Modify: `docs/_config.yml`, `docs/Gemfile`, `docs/Gemfile.lock`, `docs/_data/writing.yml`, `docs/_includes/featured.html`, `docs/_includes/writing.html`

**Interfaces:**
- Produces, on every essay document: `title` String, `topic` String, `updated` Date, `order` Integer (0-based position in `writing.yml`), `featured` Boolean, `minutes` Integer, `description` String (plain text), `description_explicit` Boolean, `section` String (`"engineering"` or `"life"`), `next_url` String, `next_title` String, `markdown_url` String (`/<slug>.md`).
- Produces: `site.essays` iterates in curated order.
- Produces: `_data/topics.yml` shaped as `{engineering: {title: "Engineering", topics: [...]}, life: {title: "Life & craft", topics: [...]}}` with the vocabulary from the spec.
- Produces: `_data/writing.yml` shaped as `[{slug: String, featured: true?}]`.
- Produces test helpers in `test/site_test.rb`: `DOCS`, `OUT` (path of the built site), `page(path) -> String`, `slugs -> Array<String>` (from `writing.yml`), `mutated_build(keep: false) { |docs_copy| … } -> [Boolean ok, String log]`, and `last_build_page(path) -> String` (reads from the most recent `keep: true` build).

- [ ] **Step 1: Branch and harness.** `git switch -c redesign`. Add `gem "minitest"` and pin `gem "jekyll", "~> 4.4"` in `docs/Gemfile`; run `bundle install` and `bundle lock --add-platform x86_64-linux`. Write `test/site_test.rb`: it builds `docs/` once into a temp directory with `bundle exec jekyll build -s <docs> -d <tmp>` and fails fast if the build fails. `mutated_build` copies `docs/` (without `_site`, `.jekyll-cache`) to a temp directory, yields it for edits, builds it, and returns the exit status and combined output.

- [ ] **Step 2: Write the failing tests.**

```ruby
def test_every_listed_essay_is_built_at_its_slug
  assert_equal Dir[File.join(DOCS, "_essays/*.md")].size, slugs.size
  slugs.each { |s| assert File.exist?(File.join(OUT, "#{s}.html")), s }
end

def test_essay_h1_is_the_title
  assert_includes page("thoughtful-design.html"), "<h1>You Can Tell</h1>"
  assert_match(/<h1>Don(’|&rsquo;|&#8217;)t Defend\. Explain\.<\/h1>/, page("feedback.html"))
end

def test_build_fails_without_updated
  ok, log = mutated_build { |d| strip_key(d, "_essays/stay-in-motion.md", "updated") }
  refute ok
  assert_match(/stay-in-motion.*updated/, log)
end

def test_build_fails_on_unknown_topic
  ok, log = mutated_build { |d| set_key(d, "_essays/stay-in-motion.md", "topic", "Crafts") }
  refute ok
  assert_match(/stay-in-motion.*Crafts/, log)
end

def test_build_fails_when_essay_is_not_in_writing_yml
  ok, log = mutated_build { |d| FileUtils.cp(File.join(d, "_essays/stay-in-motion.md"), File.join(d, "_essays/unlisted.md")) }
  refute ok
  assert_match(/unlisted/, log)
end

def test_build_fails_when_writing_yml_names_a_missing_essay
  ok, log = mutated_build { |d| File.write(File.join(d, "_data/writing.yml"), "- slug: ghost\n", mode: "a") }
  refute ok
  assert_match(/ghost/, log)
end

def test_build_fails_when_heading_first_essay_has_no_description
  ok, log = mutated_build { |d| strip_key(d, "_essays/beliefs.md", "description") }
  refute ok
  assert_match(/beliefs.*description/, log)
end

def test_derived_description_is_plain_text
  ok, = mutated_build(keep: true) { |d| replace_first_paragraph(d, "_essays/stay-in-motion.md", "Mastery *doesn't* sit [still](https://example.com).") }
  assert ok
  assert_includes last_build_page("stay-in-motion.html"), %(content="Mastery doesn&#39;t sit still.")
end
```

`strip_key`, `set_key`, and `replace_first_paragraph` are small helpers in the same file.

- [ ] **Step 3: Run and confirm they fail.** `cd docs && mise exec -- bundle exec ruby ../test/site_test.rb`. Expected: failures, because `_essays/` does not exist.

- [ ] **Step 4: Configure.** `_config.yml` gains `title: Evan Sims`, `author: Evan Sims`, `url: https://evansims.com`, `description:` (the home meta description from the spec), the `essays` collection with `output: true` and `permalink: /:name`, a default of `layout: essay` for type `essays`, and `exclude: [Gemfile, Gemfile.lock, .mise.toml]`. Write `_data/topics.yml`.

- [ ] **Step 5: Migrate the essays** with a throwaway script kept in the scratchpad, not the repo. For each slug in `writing.yml`: `git mv docs/<slug>.md docs/_essays/<slug>.md`, then replace the frontmatter with `title` (the old `header` value, same quoting), `topic` (spec table), `updated` (`2026-11-20` for `the-interface-is-the-speed-limit`, `2026-04-29` for the rest), plus `description` for `beliefs` and `the-wisdom-tax` (spec copy) and `lede: false` for `the-wisdom-tax`. Leave every byte after the closing `---` alone. Rewrite `writing.yml` as slugs with the existing `featured` flags.

- [ ] **Step 6: Verify the migration.** Both commands must print nothing:

```bash
for f in docs/_essays/*.md; do s=$(basename "$f"); diff <(git show main:docs/"$s" | awk 'f>=2{print} /^---$/{f++}') <(awk 'f>=2{print} /^---$/{f++}' "$f") >/dev/null || echo "BODY CHANGED: $s"; done
for f in docs/_essays/*.md; do s=$(basename "$f"); a=$(git show main:docs/"$s" | grep -m1 '^header:' | sed 's/^header: *//'); b=$(grep -m1 '^title:' "$f" | sed 's/^title: *//'); [ "$a" = "$b" ] || echo "TITLE DIFFERS: $s"; done
```

And `ls docs/_essays | wc -l` prints `33`.

- [ ] **Step 7: Write `docs/_plugins/essays.rb`**: one `Jekyll::Hooks.register :site, :post_read` block that validates and enriches as the Interfaces block describes, then sorts `site.collections["essays"].docs` by `order`.
  - Validation aborts the build with a one-line message containing the slug: missing `title`, `topic`, or `updated`; `topic` not in `topics.yml`; essay not in `writing.yml`; `writing.yml` slug without a file; first block is a heading and `description` is absent.
  - `minutes`: body word count divided by 230, rounded up, minimum 1.
  - Derived `description`: the body's first block, with emphasis markers, inline code ticks, and link syntax reduced to their text, whitespace collapsed.
  - `next_*`: the following essay in curated order; the last wraps to the first.

- [ ] **Step 8: Bare essay layout and old includes.** `essay.html` outputs a complete minimal document: `<h1>{{ page.title | smartify }}</h1>`, `<meta name="description" content="{{ page.description | escape }}">`, and `{{ content }}`. Point `featured.html` and `writing.html` at `site.essays` so the old home and writing pages keep building until Task 4 replaces them.

- [ ] **Step 9: Run the tests.** Expected: all pass, and the build log shows no warnings from these files.

- [ ] **Step 10: Commit.** `git add -A && git commit -m "feat: move essays into a collection with a validated content model"`

---

### Task 2: Design system and page shell

**Files:**
- Create: `docs/assets/css/site.css`, `docs/assets/fonts/newsreader-latin-roman.woff2`, `docs/assets/fonts/newsreader-latin-italic.woff2`, `docs/assets/fonts/OFL-Newsreader.txt`, `docs/_includes/head.html`, `docs/_includes/theme.html`, `docs/_includes/masthead.html`, `docs/_includes/footer.html`, `docs/_og/card.html`, `docs/assets/og.png`
- Rewrite: `docs/_layouts/default.html`, `docs/site.webmanifest`
- Recompress: `docs/android-chrome-512x512.png`, `docs/android-chrome-192x192.png`, `docs/apple-touch-icon.png`
- Delete: `docs/_sass/main.scss`, `docs/assets/css/styles.scss`, `docs/assets/fonts/InterVariable.woff2`, `docs/_data/metadata.yml`, `docs/_layouts/blog.html`

**Interfaces:**
- Consumes: `site.title`, `site.description`, `site.url` from Task 1.
- Produces: layout `default`. It renders `{{ content }}` inside `<main id="main">`, between the masthead and footer, inside `<div class="wrap">`. Page variables it reads: `title` (absent on Home), `description` (falls back to `site.description`), `og_type` (default `website`).
- Produces: `<title>` is `Evan Sims` on Home and `{{ page.title }} — Evan Sims` elsewhere.
- Produces shared CSS: the six color tokens, `--serif`, `--sans`, and the classes `.wrap`, `.mast`, `.label`, `.sec`, `.sec-h`, `.foot`, `.skip`, `.theme`. Later tasks append their own sections to `site.css`.
- Produces: `head.html` has no JSON-LD yet. Task 5 adds it.

- [ ] **Step 1: Ask Evan for a yes, then fetch the fonts.** Newsreader variable (optical size and weight axes), Latin subset, roman and italic, from Fontsource: `https://cdn.jsdelivr.net/fontsource/fonts/newsreader:vf@latest/latin-opsz-normal.woff2` and `…/latin-opsz-italic.woff2`. License text from `https://raw.githubusercontent.com/google/fonts/main/ofl/newsreader/OFL.txt`. Check each font with `file`; it must report Web Open Font Format (Version 2). If those URLs have moved, take the same two files from the `@fontsource-variable/newsreader` package.

- [ ] **Step 2: Write the failing tests.**

```ruby
TOKENS = {
  light: { paper: "#f5f1e8", ink: "#1c1a16", soft: "#4a463d", muted: "#6b6558", rule: "#d8d1c1", accent: "#b23a1c" },
  dark:  { paper: "#13120f", ink: "#ece6d9", soft: "#c4bdae", muted: "#8f8878", rule: "#2d2a24", accent: "#e8805c" }
}

def test_tokens_are_in_the_stylesheet_and_meet_aa
  css = page("assets/css/site.css")
  TOKENS.each_value do |t|
    t.each_value { |hex| assert_includes css, hex }
    %i[ink soft muted accent].each { |k| assert_operator contrast(t[k], t[:paper]), :>=, 4.5, k }
  end
end

def test_stylesheet_budget_and_no_remote_urls
  css = page("assets/css/site.css")
  assert_operator css.bytesize, :<, 20_000
  refute_match(/url\(\s*["']?https?:/, css)
  assert_equal 2, Dir[File.join(OUT, "assets/fonts/*.woff2")].size
end

def test_every_page_has_complete_head
  html_pages.each do |path, html|
    assert_includes html, %(<html lang="en"), path
    assert_equal 1, html.scan("<title>").size, path
    %w[description og:title og:description og:url og:image og:type twitter:card].each { |m| assert_match(/(name|property)="#{m}" content="[^"]+"/, html, "#{path} #{m}") }
    assert_match(%r{<link rel="canonical" href="https://evansims\.com/[^"]*">}, html, path)
    assert_equal 2, html.scan('name="theme-color"').size, path
    assert_includes html, %(<main id="main"), path
    assert_match(/<nav aria-label="[^"]+"/, html, path)
  end
  titles = html_pages.map { |_, h| h[/<title>(.*?)<\/title>/m, 1] }
  assert_equal titles.size, titles.uniq.size
end

def test_no_third_party_requests
  html_pages.each do |path, html|
    refute_match(/<iframe/i, html, path)
    refute_match(/<(script|img|source|video|audio)[^>]+src="https?:/i, html, path)
    refute_match(/<link[^>]+rel="(stylesheet|preload|icon)"[^>]+href="https?:/i, html, path)
  end
end

def test_theme_toggle_degrades_without_javascript
  home = page("index.html")
  assert_match(/<button[^>]*class="theme"[^>]*hidden/, home)
  assert_equal 1, home.scan(/<script(?![^>]*ld\+json)/).size
  assert_includes home, "try"
end

def test_attribute_escaping
  assert_includes page("docs.html"), %(content="Documentation has changed. Here&#39;s what &quot;great&quot; means now.")
end

def test_manifest_and_icons
  assert_equal "Evan Sims", JSON.parse(page("site.webmanifest"))["name"]
  assert_operator File.size(File.join(OUT, "android-chrome-512x512.png")), :<, 150_000
end
```

`html_pages` returns `{relative_path => html}` for every `.html` file in `OUT`. `contrast(a, b)` is the WCAG relative-luminance ratio.

- [ ] **Step 3: Run and confirm they fail.**

- [ ] **Step 4: Write `site.css`**: `@font-face` for the two files (`font-weight: 200 800`, `font-display: swap`), tokens on `:root`, dark tokens under `@media (prefers-color-scheme: dark)` scoped to `:root:not([data-theme="light"])` and again under `:root[data-theme="dark"]`, base element styles, and the shared classes. Take sizes and spacing from the spec's type and layout sections and from the mockup's `a-css` block. Labels use `--sans`, the system stack in the spec. Add a visible `:focus-visible` style, the skip link, nav targets at least 44px tall, `@view-transition { navigation: auto; }`, and a `prefers-reduced-motion` block that turns transitions off.

- [ ] **Step 5: Write the shell.** `head.html` (everything `test_every_page_has_complete_head` names, plus icon links, the manifest link, a preload for the roman font, the feed autodiscovery link to `/feed.xml`, and `theme-color` metas for `#f5f1e8` light and `#13120f` dark), `theme.html`, `masthead.html`, `footer.html`, `default.html`.
  - Theme script: reads `localStorage.theme` inside `try`, sets `document.documentElement.dataset.theme` when it is `light` or `dark`, un-hides `.theme`, and on click flips the effective theme and stores it.
  - Masthead: name linking to `/`; nav with Writing (`/writing`), Talks (`/talks`), Contact (`mailto:` from `socials.yml`), and the toggle button with an `aria-label`.
  - Footer: the email as the large link, then GitHub, LinkedIn, Bluesky, X with `rel="me"`, RSS (`/feed.xml`), `/llms.txt`, and `© {{ site.time | date: "%Y" }} Evan Sims`.

- [ ] **Step 6: Manifest, icons, share image.** Manifest: `name` and `short_name` "Evan Sims", `theme_color` and `background_color` `#f5f1e8`. Recompress the three PNG icons with `magick` (strip metadata, reduce palette) until the 512px icon is under 150 KB and looks the same at icon size. Write `_og/card.html` as a 1200×630 page in the same tokens (name, the hero label, the hero headline) and render it:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --hide-scrollbars --window-size=1200,630 --screenshot=docs/assets/og.png "file://$PWD/docs/_og/card.html"
```

Open `og.png` and confirm it is 1200×630 with the type rendered in Newsreader.

- [ ] **Step 7: Delete the superseded files** listed above and point every remaining page at `layout: default`.

- [ ] **Step 8: Run the tests.** Expected: all pass, no Sass warning in the build log.

- [ ] **Step 9: Commit.** `git commit -m "feat: add editorial design system and page shell"`

---

### Task 3: Essay page

**Files:**
- Rewrite: `docs/_layouts/essay.html`
- Create: `docs/_includes/byline.html`, `docs/assets/images/evan.jpg`
- Modify: `docs/assets/css/site.css` (essay, prose, and print sections)

**Interfaces:**
- Consumes: layout `default`; essay fields `title`, `topic`, `minutes`, `lede`, `next_url`, `next_title` from Task 1.
- Produces: `essay.html` sets `og_type: article` and renders `<article class="post">` with `<div class="meta">`, `<h1>`, `<div class="prose">` (plus class `no-lede` when `lede` is `false`), the byline include, and `<nav class="next" aria-label="More writing">`. The byline `<img>` carries its attributes in the order `src`, `alt`, `width`, `height`. Task 5 adds one link inside `.meta`.

- [ ] **Step 1: Write the failing tests.**

```ruby
def test_essay_structure
  html = page("the-interface-is-the-speed-limit.html")
  assert_equal 1, html.scan("<h1").size
  assert_match(%r{<div class="meta">.*Systems.*6 min}m, html)
  assert_includes html, %(property="og:type" content="article")
  assert_match(/<img[^>]+src="\/assets\/images\/evan\.jpg"[^>]+alt="Evan Sims"[^>]+width="\d+"[^>]+height="\d+"/, html)
  assert_match(%r{<div class="meta">.*1 min}m, page("both-directions-kill-you.html"))
end

def test_lede_opt_out
  assert_match(/class="prose no-lede"/, page("the-wisdom-tax.html"))
  assert_match(/class="prose"/, page("both-directions-kill-you.html"))
end

def test_next_wraps
  last, first = slugs.last, slugs.first
  assert_match(%r{<nav class="next"[^>]*>.*href="/#{first}"}m, page("#{last}.html"))
end

def test_print_styles_exist
  assert_includes page("assets/css/site.css"), "@media print"
end
```

- [ ] **Step 2: Run and confirm they fail.**

- [ ] **Step 3: Audit what the prose must style.** Run each and note the hits:

```bash
cd docs/_essays && grep -l '^```' *.md; grep -l '^|' *.md; grep -l '^>' *.md; grep -l '!\[' *.md; grep -lE '^#{3,4} ' *.md; grep -lE '^[0-9]+\. ' *.md; grep -l '^---$' <(for f in *.md; do awk 'f>=2{print FILENAME": "$0} /^---$/{f++}' "$f"; done)
```

Every element that appears gets a prose style. Elements that never appear get none.

- [ ] **Step 4: Build the page.** Create `evan.jpg` at 192px from `android-chrome-512x512.png` with `magick` (quality about 82). Write `byline.html` (headshot at 48px display size, name, the byline bio from the spec) and `essay.html`. Add the essay CSS: 41rem measure, the lede rule on `.prose:not(.no-lede) > p:first-child`, headings, lists, blockquote, `hr`, links, and the print block (hide masthead, byline, next, footer; black on white).

- [ ] **Step 5: Run the tests.** Expected: pass.

- [ ] **Step 6: Check in a browser.** Serve with `bundle exec jekyll serve`. At 320, 390, and 1280px, in light and dark, open `the-interface-is-the-speed-limit`, `agentic-engineering`, `beliefs`, `docs`, `the-wisdom-tax`, and the supplement essay. On each, this must be `true` in the console: `document.documentElement.scrollWidth <= window.innerWidth`. Compare the 1280px and 390px views against the mockup's essay page and fix differences in spacing or type.

- [ ] **Step 7: Commit.** `git commit -m "feat: add essay layout with lede, byline, and print styles"`

---

### Task 4: Home, Writing, Talks, and 404

**Files:**
- Create: `docs/_layouts/home.html`, `docs/_layouts/page.html`, `docs/_includes/essay-list.html`, `docs/_data/record.yml`, `docs/_data/talks.yml`, `docs/404.html`
- Rewrite: `docs/index.md`, `docs/writing.md`, `docs/talks.md`
- Modify: `docs/assets/css/site.css`
- Delete: `docs/videos.md`, `docs/podcast.md`, `docs/_includes/featured.html`, `docs/_includes/writing.html`, `docs/_includes/youtube.html`

**Interfaces:**
- Consumes: layout `default`, shared classes, `site.essays` and essay fields from Task 1.
- Produces: `{% include essay-list.html essays=<array> %}` renders `<ol class="toc">` with one `<li>` per essay: title link, description, and `Topic · N min`. It is the only place `class="toc"` appears. Record organizations on Home are `<h3>` elements that begin with the organization name. Writing group headings are `<h2>`.
- Produces: `index.md` frontmatter keys `label`, `headline` (HTML allowed), `lead`, `personal`, and `elsewhere` (list of `{title, body, link_text, link_url}`). `record.yml` rows are `{when, org, role, body}`. `talks.yml` rows are `{id, title, host}`.
- Produces: `permalink: /writing` and `permalink: /talks` on those pages; `404.html` at `/404.html`.

- [ ] **Step 1: Write the failing tests.**

```ruby
def test_home_sections
  home = page("index.html")
  assert_includes home, "people on the other end"
  orgs = home.scan(/<h3>(InferaDB|OpenFGA at Okta|Auth0|Ushahidi)/).flatten
  assert_equal ["InferaDB", "OpenFGA at Okta", "Auth0", "Ushahidi"], orgs
  featured = YAML.load_file(File.join(DOCS, "_data/writing.yml")).select { |i| i["featured"] }.map { |i| i["slug"] }
  assert_equal featured, home[/<ol class="toc">.*?<\/ol>/m].scan(/href="\/([^"]+)"/).flatten
  assert_includes home, "All #{slugs.size} essays"
  assert_includes home, 'href="/resume.pdf"'
  refute_match(/podcast/i, home)
end

def test_writing_index_groups_and_order
  html = page("writing.html")
  eng, life = html.split("Life &amp; craft")
  assert_includes eng, "<h2>Engineering</h2>"
  in_lists = ->(part) { part.scan(/<ol class="toc">.*?<\/ol>/m).join.scan(/href="\/([^"]+)"/).flatten }
  assert_equal slugs.sort, in_lists.(html).sort
  [eng, life].each { |part| assert_equal slugs & in_lists.(part), in_lists.(part) }
  assert_match(/Systems · 6 min/, html)
end

def test_talks_are_links_not_embeds
  html = page("talks.html")
  %w[9j-LLLTvW34 3M_gu53m2_g KmRr1Fz_6Zo KK16e8EPuDU I1vhuWceQ3s].each { |id| assert_includes html, "https://www.youtube.com/watch?v=#{id}" }
  assert_includes html, "Coffee &amp; Code"
end

def test_removed_and_added_pages
  refute File.exist?(File.join(OUT, "videos.html"))
  refute File.exist?(File.join(OUT, "podcast.html"))
  nf = page("404.html")
  assert_includes nf, 'href="/"'
  assert_includes nf, 'href="/writing"'
end
```

- [ ] **Step 2: Run and confirm they fail.**

- [ ] **Step 3: Write the data and pages** with the spec's copy: `record.yml`, `talks.yml`, `index.md` frontmatter, `home.html` (sections in the spec's order, section headers as `.sec-h` with the "Résumé (PDF)" and "All N essays" links), `essay-list.html`, `page.html`, `writing.md` (two groups from `topics.yml`, each `site.essays | where: "section", key`), `talks.md` (rows: title, host, "Watch on YouTube"), `404.html`. Append the home, list, and talks CSS, with rows stacking under 720px as in the mockup. Delete the superseded files.

- [ ] **Step 4: Run the tests.** Expected: pass.

- [ ] **Step 5: Check in a browser** at 320, 390, 768, 1280, and 1920px in both themes: Home, Writing, Talks, and a bad URL for the 404. Same overflow check as Task 3. Compare Home at 1280px and 390px against the mockup's home page.

- [ ] **Step 6: Commit.** `git commit -m "feat: add home, writing index, talks, and 404 pages"`

---

### Task 5: Agent surface

**Files:**
- Create: `docs/_plugins/agent_files.rb`, `docs/llms.txt`, `docs/feed.xml`, `docs/sitemap.xml`, `docs/robots.txt`, `docs/_includes/jsonld-person.html`, `docs/_includes/jsonld-essay.html`
- Modify: `docs/_includes/head.html`, `docs/_layouts/essay.html`

**Interfaces:**
- Consumes: essay fields from Task 1, including `markdown_url`, `description_explicit`, `updated`.
- Produces: `/<slug>.md` for every essay, `/llms-full.txt`, `/llms.txt`, `/feed.xml`, `/sitemap.xml`, `/robots.txt`.
- Markdown copy format, exactly:

```
# <title>

> <description>            (this line and the blank after it only when description_explicit)

<raw body, trimmed>

---

Source: https://evansims.com/<slug>
```

- [ ] **Step 1: Write the failing tests.**

```ruby
def test_markdown_copies
  slugs.each do |s|
    md = page("#{s}.md")
    refute_match(/\A---/, md, s)
    assert_match(/\n---\n\nSource: https:\/\/evansims\.com\/#{s}\n?\z/, md, s)
    assert_includes md, raw_body(s).strip, s
  end
  assert_match(/\A# Things I Believe\n\n> What I hold to/, page("beliefs.md"))
  assert_match(/\A# Both Directions Kill You\n\nThere is no middle\./, page("both-directions-kill-you.md"))
  assert_equal 1, page("both-directions-kill-you.md").scan("There is no middle.").size
end

def test_essay_links_to_its_markdown
  html = page("feedback.html")
  assert_includes html, %(<link rel="alternate" type="text/markdown" href="/feedback.md">)
  assert_match(%r{<div class="meta">.*href="/feedback\.md"}m, html)
end

def test_llms_txt
  txt = page("llms.txt")
  assert txt.start_with?("# Evan Sims\n\n> ")
  ["## Engineering", "## Life & craft", "## Elsewhere"].each { |h| assert_includes txt, h }
  links = txt.scan(%r{\]\((https://evansims\.com/[^)]+\.md)\)}).flatten
  assert_equal slugs.sort, links.map { |l| File.basename(l, ".md") }.sort
  full = page("llms-full.txt")
  slugs.each { |s| assert_includes full, "Source: https://evansims.com/#{s}" }
end

def test_feed_is_valid_and_stable
  doc = REXML::Document.new(page("feed.xml"))
  assert_equal "http://www.w3.org/2005/Atom", doc.root.namespace
  entries = doc.root.get_elements("entry")
  assert_equal slugs.size, entries.size
  stamps = entries.map { |e| e.elements["updated"].text }
  stamps.each { |t| assert_match(/\A\d{4}-\d\d-\d\dT00:00:00Z\z/, t) }
  assert_equal stamps.max, doc.root.elements["updated"].text
  assert_includes entries.map { |e| e.elements["title"].text }, "Don't Defend. Explain."
  second_out = build_again
  assert_equal File.binread(File.join(OUT, "feed.xml")), File.binread(File.join(second_out, "feed.xml"))
end

def test_sitemap_and_robots
  locs = REXML::Document.new(page("sitemap.xml")).root.get_elements("url/loc").map(&:text)
  assert_equal slugs.size + 3, locs.size
  assert_includes locs, "https://evansims.com/"
  robots = page("robots.txt")
  assert_includes robots, "Sitemap: https://evansims.com/sitemap.xml"
  refute_match(/^Disallow: \/\s*$/, robots)
end

def test_json_ld
  blocks = ->(html) { html.scan(%r{<script type="application/ld\+json">(.*?)</script>}m).flatten.map { |j| JSON.parse(j) } }
  person = blocks.(page("index.html")).find { |b| b["@type"] == "Person" }
  assert_equal "InferaDB", person["worksFor"]["name"]
  assert_equal 4, person["sameAs"].size
  html_pages.each_value { |h| blocks.(h) }
  post = blocks.(page("docs.html")).find { |b| b["@type"] == "BlogPosting" }
  assert_equal "Documentation", post["headline"]
  assert_kind_of Integer, post["wordCount"]
  refute post.key?("datePublished")
  refute post.key?("dateModified")
end
```

`raw_body(slug)` returns the source file's text after its frontmatter. `build_again` builds a second copy and returns its path.

- [ ] **Step 2: Run and confirm they fail.**

- [ ] **Step 3: Write `agent_files.rb`**: a `:site, :post_write` hook that reads each essay's source file, drops the frontmatter, and writes the Markdown copy in the format above into `site.dest`; then writes `llms-full.txt` as `# Evan Sims`, the site description as a blockquote, and every copy in curated order separated by a blank line.

- [ ] **Step 4: Write the templates.**
  - `llms.txt`: the llmstxt.org shape from the spec. Each essay line is `- [Title](https://evansims.com/<slug>.md): description`. Elsewhere lists Talks, Résumé, and the email address.
  - `feed.xml`: Atom. Feed `id` and `link` are the site URL; feed `updated` is the newest essay `updated`. Entries sorted by `updated` descending, then curated order. Each entry: `title`, `link`, `id` (canonical URL), `updated` as `YYYY-MM-DDT00:00:00Z`, `summary` (description), `content type="html"` (rendered body, XML-escaped), `author`.
  - `sitemap.xml`: `/`, `/writing`, `/talks`, and each essay with `lastmod` from `updated`.
  - `robots.txt`: `User-agent: *`, `Allow: /`, a blank line, `Sitemap: https://evansims.com/sitemap.xml`.
  - `jsonld-person.html` (Home only): `Person` with `@id` `https://evansims.com/#person`, `name`, `url`, `image`, `jobTitle` "Co-founder & CTO", `worksFor` Organization InferaDB with its URL, `sameAs` for GitHub, LinkedIn, Bluesky, and X; plus a `WebSite` node. Build values with `jsonify`.
  - `jsonld-essay.html`: `BlogPosting` with `headline`, `description`, `url`, `mainEntityOfPage`, `wordCount`, `articleSection`, and `author` referencing the person `@id`. No date fields.
  - `head.html`: include the two JSON-LD files where they apply, and the `text/markdown` alternate link on essays. `essay.html`: add the "Markdown" link to `.meta`.

- [ ] **Step 5: Run the tests.** Expected: pass.

- [ ] **Step 6: Commit.** `git commit -m "feat: add markdown copies, llms.txt, feed, sitemap, and structured data"`

---

### Task 6: Deploy workflow, cleanup, and project notes

**Files:**
- Create: `.github/workflows/pages.yml`
- Delete: `docs/assets/images/blog/` (21 files), `docs/_data/.gitkeep`, `docs/_includes/.gitkeep`
- Modify: `CLAUDE.md`

**Interfaces:**
- Consumes: the test command from Task 1.

- [ ] **Step 1: Confirm nothing references the images.** `grep -rn "assets/images/blog" docs --include='*.md' --include='*.html' --include='*.css' --include='*.yml' --exclude-dir=_site` prints nothing. Then `git rm -r docs/assets/images/blog` and remove the two `.gitkeep` files.

- [ ] **Step 2: Write the workflow.** Triggers: push to `main`, and `workflow_dispatch`. Permissions: `contents: read`, `pages: write`, `id-token: write`. Concurrency group `pages`, not cancelling in-progress runs.
  - Job `build`: `actions/checkout@v7`; `ruby/setup-ruby@v1` with `ruby-version: "4.0"`, `bundler-cache: true`, `working-directory: docs`; `actions/configure-pages@v6`; `bundle exec ruby ../test/site_test.rb` in `docs`; `bundle exec jekyll build` in `docs` with `JEKYLL_ENV: production`; `actions/upload-pages-artifact@v5` with `path: docs/_site`.
  - Job `deploy`: needs `build`, environment `github-pages`, `actions/deploy-pages@v5`.

- [ ] **Step 3: Validate it.** `ruby -ryaml -e 'YAML.load_file(".github/workflows/pages.yml")'` exits 0. If `actionlint` is installed, it reports nothing.

- [ ] **Step 4: Update `CLAUDE.md`** site notes per the spec's CLAUDE.md section: essay location, `writing.yml` meaning, frontmatter fields (including that `updated` is hidden, required, and hand-set), single essay layout, the test command, the Actions build. Replace the line about `header:` and `name:`. Leave the writing-style section as is.

- [ ] **Step 5: Run the tests and commit.** `git commit -m "feat: build and deploy with GitHub Actions; remove unused assets"`

---

### Task 7: GitHub profile README

**Files:**
- Rewrite: `README.md`

- [ ] **Step 1: Replace `README.md`** with the Markdown block under "README" in the spec's "Copy for approval", exactly.

- [ ] **Step 2: Verify.** The three essay links name slugs that exist: `for s in the-interface-is-the-speed-limit agentic-engineering developer-experience; do test -f docs/_essays/$s.md || echo "MISSING $s"; done` prints nothing. `grep -c '—' README.md` prints `0`.

- [ ] **Step 3: Commit.** `git commit -m "docs: rewrite profile README"`

---

### Task 8: Whole-site verification and cutover

**Files:** none new.

- [ ] **Step 1: Clean build.** `cd docs && mise exec -- bundle exec jekyll build 2>&1 | grep -ciE 'warn|deprecat'` prints `0`. The full test suite passes.

- [ ] **Step 2: Browser matrix.** Serve locally. For Home, Writing, Talks, and two essays, at 320, 390, 768, 1280, and 1920px, in light and dark: no horizontal scroll, no overlapping or clipped text. Tab through Home: the skip link appears first, every control shows focus, and the toggle switches theme and survives a reload.

- [ ] **Step 3: Degraded modes.** With JavaScript disabled, Home and an essay read fully and the toggle is absent. With CSS disabled, heading order and link text still make sense.

- [ ] **Step 4: Network.** Load Home and an essay with the network panel open. Every request is to the local host.

- [ ] **Step 5: Accessibility scan.** Run axe-core against Home and an essay in both themes. Expected: zero violations. Fix any and re-run Step 1.

- [ ] **Step 6: Spec walk.** Read the spec's nine Verification items and confirm each one, naming the test or check that proves it.

- [ ] **Step 7: Hand to Evan.** Show the local site. With his yes: push `redesign` and open the pull request.

- [ ] **Step 8: Cutover, each with Evan's explicit yes.** Switch the Pages source to GitHub Actions (`gh api -X PUT repos/evansims/evansims/pages -f build_type=workflow`), confirm the live site still serves, then squash-merge. Watch the workflow run to completion.

- [ ] **Step 9: Check production.**

```bash
for p in / /writing /talks /both-directions-kill-you /both-directions-kill-you.md /llms.txt /llms-full.txt /feed.xml /sitemap.xml /robots.txt; do printf '%s %s\n' "$(curl -s -o /dev/null -w '%{http_code} %{content_type}' https://evansims.com$p)" "$p"; done
curl -s -o /dev/null -w '%{http_code}\n' https://evansims.com/videos
```

Expected: `200` for the first ten, `404` for the last. Report the content type GitHub Pages serves for `.md`.
