# frozen_string_literal: true

require "minitest/autorun"
require "digest"
require "fileutils"
require "json"
require "open3"
require "rexml/document"
require "tmpdir"
require "yaml"

Encoding.default_external = Encoding::UTF_8

DOCS = File.expand_path("../docs", __dir__)
TEMP_DIRS = []

def jekyll_build(source)
  out = Dir.mktmpdir("site")
  TEMP_DIRS << out
  log, status = Open3.capture2e("bundle", "exec", "jekyll", "build", "-s", source, "-d", out, chdir: DOCS)
  [status.success?, log, out]
end

built, BUILD_LOG, OUT = jekyll_build(DOCS)
abort(BUILD_LOG) unless built
Minitest.after_run { TEMP_DIRS.each { |dir| FileUtils.rm_rf(dir) } }

module SiteHelpers
  def page(path)
    File.read(File.join(OUT, path))
  end

  def slugs
    YAML.load_file(File.join(DOCS, "_data/writing.yml")).map { |item| item["slug"] }
  end

  def mutated_build(keep: false)
    copy = Dir.mktmpdir("docs")
    TEMP_DIRS << copy
    Dir.children(DOCS).each do |child|
      next if %w[_site .jekyll-cache vendor .bundle].include?(child)

      FileUtils.cp_r(File.join(DOCS, child), copy)
    end
    yield copy
    ok, log, out = jekyll_build(copy)
    @last_out = out if keep
    [ok, log]
  end

  def last_build_page(path)
    File.read(File.join(@last_out, path))
  end

  def html_pages
    Dir[File.join(OUT, "**/*.html")].to_h { |path| [path.delete_prefix("#{OUT}/"), File.read(path)] }
  end

  def luminance(hex)
    red, green, blue = hex.delete("#").scan(/../).map do |pair|
      value = pair.to_i(16) / 255.0
      value <= 0.03928 ? value / 12.92 : ((value + 0.055) / 1.055)**2.4
    end
    0.2126 * red + 0.7152 * green + 0.0722 * blue
  end

  def contrast(first, second)
    lighter, darker = [luminance(first), luminance(second)].sort.reverse
    (lighter + 0.05) / (darker + 0.05)
  end

  def split_front_matter(text)
    match = text.match(/\A(---\n.*?\n---\n)(.*)\z/m)
    [match[1], match[2]]
  end

  def strip_key(dir, rel, key)
    path = File.join(dir, rel)
    File.write(path, File.read(path).sub(/^#{key}:.*\n/, ""))
  end

  def set_key(dir, rel, key, value)
    path = File.join(dir, rel)
    File.write(path, File.read(path).sub(/^#{key}:.*$/, "#{key}: #{value}"))
  end

  def add_key(dir, rel, key, value)
    path = File.join(dir, rel)
    File.write(path, File.read(path).sub(/\A---\n/, "---\n#{key}: #{value}\n"))
  end

  def replace_first_paragraph(dir, rel, text)
    path = File.join(dir, rel)
    front, body = split_front_matter(File.read(path))
    blocks = body.strip.split(/\n{2,}/)
    blocks[0] = text
    File.write(path, "#{front}\n#{blocks.join("\n\n")}\n")
  end
end

class ContentModelTest < Minitest::Test
  include SiteHelpers

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

  def test_build_fails_without_title
    ok, log = mutated_build { |d| strip_key(d, "_essays/stay-in-motion.md", "title") }
    refute ok
    assert_match(/stay-in-motion.*title/, log)
  end

  def test_build_fails_on_malformed_updated
    ok, log = mutated_build { |d| set_key(d, "_essays/stay-in-motion.md", "updated", "last April") }
    refute ok
    assert_match(/stay-in-motion.*updated/, log)
  end

  def test_build_fails_on_blank_title
    ok, log = mutated_build { |d| set_key(d, "_essays/stay-in-motion.md", "title", '""') }
    refute ok
    assert_match(/stay-in-motion.*title/, log)
  end

  def test_datetime_updated_names_the_essay
    ok, log = mutated_build { |d| set_key(d, "_essays/stay-in-motion.md", "updated", "2026-04-29 10:00:00") }
    refute ok
    assert_match(/stay-in-motion.*updated/, log)
  end

  def test_crlf_line_endings_build
    ok, = mutated_build(keep: true) do |d|
      path = File.join(d, "_essays/stay-in-motion.md")
      File.write(path, File.read(path).gsub("\n", "\r\n"))
    end
    assert ok
    assert_includes last_build_page("stay-in-motion.html"), %(content="Mastery doesn&#39;t sit still.")
  end

  def test_unpublished_but_listed_essay_says_so
    ok, log = mutated_build { |d| add_key(d, "_essays/stay-in-motion.md", "published", "false") }
    refute ok
    assert_match(/stay-in-motion.*published/, log)
  end

  def test_writing_yml_entry_without_a_slug_is_named
    ok, log = mutated_build { |d| File.write(File.join(d, "_data/writing.yml"), "- name: Oops\n", mode: "a") }
    refute ok
    assert_match(/writing\.yml.*entry 36.*slug/, log)
  end

  def test_duplicate_slug_in_writing_yml_fails
    ok, log = mutated_build do |d|
      File.write(File.join(d, "_data/writing.yml"), "- slug: stay-in-motion\n", mode: "a")
    end
    refute ok
    assert_match(/stay-in-motion.*more than once/, log)
  end

  def test_long_opening_paragraph_needs_a_description
    long = "This opening sentence keeps going well past the point where it could serve as a one-line " \
           "description, because it was written as an ordinary paragraph and not as a short claim to lead with."
    ok, log = mutated_build { |d| replace_first_paragraph(d, "_essays/stay-in-motion.md", long) }
    refute ok
    assert_match(/stay-in-motion.*description/, log)
  end

  def test_build_fails_on_unknown_topic
    ok, log = mutated_build { |d| set_key(d, "_essays/stay-in-motion.md", "topic", "Crafts") }
    refute ok
    assert_match(/stay-in-motion.*Crafts/, log)
  end

  def test_build_fails_when_essay_is_not_in_writing_yml
    ok, log = mutated_build do |d|
      FileUtils.cp(File.join(d, "_essays/stay-in-motion.md"), File.join(d, "_essays/unlisted.md"))
    end
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

  def test_build_fails_when_opening_block_is_not_a_paragraph
    openings = ["> An epigraph.", "- first\n- second", "![A chart](/chart.png)", "<div>raw</div>",
                "Setext Heading\n==============", "```\ncode\n```"]
    openings.each do |opening|
      ok, log = mutated_build { |d| replace_first_paragraph(d, "_essays/stay-in-motion.md", opening) }
      refute ok, opening
      assert_match(/stay-in-motion.*description/, log, opening)
    end
  end

  def test_non_paragraph_opening_builds_with_a_description
    ok, = mutated_build(keep: true) do |d|
      replace_first_paragraph(d, "_essays/stay-in-motion.md", "> An epigraph.")
      add_key(d, "_essays/stay-in-motion.md", "description", '"Mastery keeps moving."')
    end
    assert ok
    assert_includes last_build_page("stay-in-motion.html"), %(content="Mastery keeps moving.")
  end

  def test_validation_failure_is_an_error_the_dev_server_survives
    script = 'require "jekyll"; load ARGV[0]; begin; Essays.stop("probe"); ' \
             'rescue StandardError => error; puts "standard:#{error.class}:#{error.message}"; end'
    plugin = File.join(DOCS, "_plugins/essays.rb")
    out, status = Open3.capture2e("bundle", "exec", "ruby", "-e", script, plugin, chdir: DOCS)
    assert status.success?, out
    assert_includes out, "standard:Jekyll::Errors::FatalException"
    assert_includes out, "probe"
  end

  def test_angle_brackets_in_titles_and_descriptions_are_text
    ok, = mutated_build(keep: true) do |d|
      set_key(d, "_essays/stay-in-motion.md", "title", '"The <dialog> Element"')
      replace_first_paragraph(d, "_essays/stay-in-motion.md", "Use Vec<T> here.")
    end
    assert ok
    essay = last_build_page("stay-in-motion.html")
    index = last_build_page("writing.html")
    assert_includes essay, "<h1>The &lt;dialog&gt; Element</h1>"
    assert_includes index, "The &lt;dialog&gt; Element"
    assert_includes index, "Use Vec&lt;T&gt; here."
    refute_includes index, "<dialog>"
    previous = slugs[slugs.index("stay-in-motion") - 1]
    assert_match(%r{<nav class="next"[^>]*>.*The &lt;dialog&gt; Element}m, last_build_page("#{previous}.html"))
  end

  def test_derived_description_is_plain_text
    ok, = mutated_build(keep: true) do |d|
      replace_first_paragraph(d, "_essays/stay-in-motion.md", "Mastery *doesn't* sit [still](https://example.com).")
    end
    assert ok
    assert_includes last_build_page("stay-in-motion.html"), %(content="Mastery doesn&#39;t sit still.")
  end
end

class ShellTest < Minitest::Test
  include SiteHelpers

  LEGACY_SLUGS = %w[
    the-interface-is-the-speed-limit both-directions-kill-you beliefs developer-experience
    agentic-engineering docs developer-marketing developer-relations developer-products
    community-moderation feedback product-engineering downtime-as-self-care prune-to-prosper
    cultivate-a-more-optimistic-future tiny-changes clarity-and-connection embrace-calm-amidst-chaos
    better-living-through-compromise hanlons-razor the-price-of-convenience thoughtful-design
    stay-in-motion mend-what-matters finding-the-right-problem identity-follows-action
    relax-nothing-matters the-cost-of-every-movement
    optimizing-health-my-daily-supplement-regimen-for-energy-longevity-and-well-being
    the-productivity-heist the-wisdom-tax how-ai-knows-what-youll-say-next
    the-art-of-building-open-source-libraries
  ].freeze

  def meta_description(html)
    html[/<meta name="description" content="([^"]*)"/, 1]
  end

  def test_legacy_essay_urls_still_build
    assert_equal 33, LEGACY_SLUGS.size
    LEGACY_SLUGS.each { |slug| assert File.exist?(File.join(OUT, "#{slug}.html")), slug }
  end

  def test_build_log_has_no_warnings
    assert_empty BUILD_LOG.lines.grep(/warn|deprecat/i)
  end

  def test_pages_have_their_own_meta_descriptions
    described = %w[index.html writing.html talks.html 404.html].map { |path| meta_description(page(path)) }
    assert_equal described.size, described.uniq.size
    assert_equal "Talks, demos, and community meetings on authorization and developer experience.", described[2]
    assert_includes described[0], "He writes about developer experience, systems, and building software."
  end

  def test_robots_follows_the_configured_url
    ok, = mutated_build(keep: true) { |d| set_key(d, "_config.yml", "url", "https://example.test") }
    assert ok
    assert_includes last_build_page("robots.txt"), "Sitemap: https://example.test/sitemap.xml"
  end

  def test_contact_links_follow_socials_yml
    ok, = mutated_build(keep: true) do |d|
      path = File.join(d, "_data/socials.yml")
      File.write(path, File.read(path).sub("mailto:hello@evansims.com", "mailto:someone@example.test"))
    end
    assert ok
    home = last_build_page("index.html")
    refute_includes home, "hello@evansims.com"
    assert_operator home.scan("mailto:someone@example.test").size, :>=, 4
  end

  def test_only_main_deploys
    workflow = YAML.load_file(File.expand_path("../.github/workflows/pages.yml", __dir__))
    upload = workflow["jobs"]["build"]["steps"].find { |step| step["uses"].to_s.include?("upload-pages-artifact") }
    assert_equal "github.ref == 'refs/heads/main'", workflow["jobs"]["deploy"]["if"]
    assert_equal "github.ref == 'refs/heads/main'", upload["if"]
  end

  TOKENS = {
    light: { paper: "#f5f1e8", ink: "#1c1a16", soft: "#4a463d", muted: "#6b6558", rule: "#d8d1c1", accent: "#b23a1c" },
    dark: { paper: "#13120f", ink: "#ece6d9", soft: "#c4bdae", muted: "#8f8878", rule: "#2d2a24", accent: "#e8805c" }
  }.freeze

  def test_tokens_are_in_the_stylesheet_and_meet_aa
    css = page("assets/css/site.css")
    TOKENS.each_value do |tokens|
      tokens.each_value { |hex| assert_includes css, hex }
      %i[ink soft muted accent].each { |key| assert_operator contrast(tokens[key], tokens[:paper]), :>=, 4.5, key }
    end
  end

  def test_stylesheet_budget_and_no_remote_urls
    css = page("assets/css/site.css")
    assert_operator css.bytesize, :<, 20_000
    refute_match(/url\(\s*["']?https?:/, css)
    assert_equal 2, Dir[File.join(OUT, "assets/fonts/*.woff2")].size
  end

  def test_stylesheet_url_carries_its_content_hash
    version = Digest::SHA256.file(File.join(OUT, "assets/css/site.css")).hexdigest[0, 10]
    pages = Dir[File.join(OUT, "**/*.html")]
    refute_empty pages
    pages.each do |path|
      links = File.read(path).scan(/<link rel="stylesheet" href="([^"]+)">/).flatten
      assert_equal ["/assets/css/site.css?v=#{version}"], links, path
    end
  end

  def test_every_page_has_complete_head
    html_pages.each do |path, html|
      assert_includes html, %(<html lang="en"), path
      assert_equal 1, html.scan("<title>").size, path
      %w[description og:title og:description og:url og:image og:type twitter:card].each do |name|
        assert_match(/(name|property)="#{name}" content="[^"]+"/, html, "#{path} #{name}")
      end
      assert_match(%r{<link rel="canonical" href="https://evansims\.com/[^"]*">}, html, path)
      assert_equal 2, html.scan('name="theme-color"').size, path
      assert_includes html, %(<main id="main"), path
      assert_match(/<nav aria-label="[^"]+"/, html, path)
    end
    titles = html_pages.map { |_, html| html[%r{<title>(.*?)</title>}m, 1] }
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
    assert_match(/try \{ stored = localStorage\.getItem\("theme"\); \} catch/, home)
    assert_match(/try \{ localStorage\.setItem\("theme", next\); \} catch/, home)
  end

  def test_attribute_escaping
    assert_includes page("docs.html"),
                    %(content="Documentation has changed. Here&#39;s what &quot;great&quot; means now.")
  end

  def test_manifest_and_icons
    assert_equal "Evan Sims", JSON.parse(page("site.webmanifest"))["name"]
    assert_operator File.size(File.join(OUT, "android-chrome-512x512.png")), :<, 150_000
  end
end

class EssayTest < Minitest::Test
  include SiteHelpers

  def test_essay_structure
    html = page("the-interface-is-the-speed-limit.html")
    assert_equal 1, html.scan("<h1").size
    assert_match(%r{<div class="meta">.*Systems.*7 min}m, html)
    assert_includes html, %(property="og:type" content="article")
    assert_match(%r{<img[^>]+src="/assets/images/evan\.jpg"[^>]+alt="Evan Sims"[^>]+width="\d+"[^>]+height="\d+"}, html)
    assert_match(%r{<div class="meta">.*1 min}m, page("both-directions-kill-you.html"))
    assert File.exist?(File.join(OUT, "assets/images/evan.jpg"))
  end

  def test_non_essay_pages_are_not_articles
    assert_includes page("index.html"), %(property="og:type" content="website")
  end

  def test_lede_opt_out
    assert_match(/class="prose no-lede"/, page("the-wisdom-tax.html"))
    assert_match(/class="prose"/, page("both-directions-kill-you.html"))
  end

  def test_essay_names_its_author_under_the_title
    assert_match(
      %r{</h1>\s*<p class="by">By <a href="/">Evan Sims</a>, co-founder and CTO of <a href="https://inferadb\.com">InferaDB</a></p>\s*</header>},
      page("the-interface-is-the-speed-limit.html")
    )
  end

  def test_byline_offers_two_actions
    byline = page("feedback.html")[%r{<footer class="byline">.*?</footer>}m]
    assert_match(%r{<a href="mailto:[^"?]+\?subject=InferaDB">Email me about InferaDB}, byline)
    assert_match(%r{<a href="https://inferadb\.com">See InferaDB}, byline)
  end

  def test_print_keeps_the_author
    print = page("assets/css/site.css")[/@media print \{.*\z/m]
    refute_match(/^\s*\.byline,?\s*$/, print)
    assert_match(/\.byline img,/, print)
    assert_match(/\.byline \.acts,/, print)
  end

  def test_masthead_marks_writing_on_essays
    assert_includes page("feedback.html"), '<a href="/writing" aria-current="true">Writing</a>'
    assert_includes page("writing.html"), '<a href="/writing" aria-current="page">Writing</a>'
    refute_match(%r{href="/writing" aria-current}, page("talks.html"))
  end

  def test_code_and_tables_cannot_widen_the_page
    css = page("assets/css/site.css")
    assert_match(/\.prose pre\s*\{[^}]*overflow-x:\s*auto/, css)
    assert_match(/\.prose table\s*\{[^}]*overflow-x:\s*auto/, css)
  end

  def test_print_styles_exist
    assert_includes page("assets/css/site.css"), "@media print"
  end
end

class PagesTest < Minitest::Test
  include SiteHelpers

  def toc_links(html)
    html.scan(%r{<ol class="toc"[^>]*>.*?</ol>}m).join.scan(%r{href="/([^"]+)"}).flatten
  end

  def test_home_sections
    home = page("index.html")
    assert_includes home, "people on the other end"
    record = home.scan(%r{<h3><a href="([^"]+)">([^<]+)</a></h3>})
    assert_equal [
      ["https://inferadb.com", "InferaDB"],
      ["https://anthropicidentity.com/", "Anthropic Identity"],
      ["https://www.okta.com", "Okta"],
      ["https://auth0.com", "Auth0"],
      ["https://www.ushahidi.com", "Ushahidi"]
    ], record
    groups = home.split('<div class="rec-group">').drop(1).map do |chunk|
      [chunk[%r{<p class="when">([^<]+)</p>}, 1], chunk.scan(%r{<h3><a href="[^"]+">([^<]+)</a></h3>}).flatten]
    end
    assert_equal [["Now", ["InferaDB", "Anthropic Identity"]], ["Previously", %w[Okta Auth0 Ushahidi]]], groups
    assert_equal 2, home.scan('<p class="when">').size
    refute_match(/Since 20\d\d|2024–25|2020–24/, home)
    assert_includes home, '<p class="role">Principal software architect</p>'
    assert_includes home, '<p class="role">Staff software engineer · OpenFGA founding engineer</p>'
    assert_includes home, "A database built only for authorization."
    assert_includes home, "helped lead Auth0 through FedRAMP certification"
    featured = YAML.load_file(File.join(DOCS, "_data/writing.yml")).select { |item| item["featured"] }.map { |item| item["slug"] }
    assert_equal featured, toc_links(home)
    assert_equal %w[
      authorization-is-a-database-problem the-interface-is-the-speed-limit an-agent-needs-its-own-identity
      beliefs developer-experience the-art-of-building-open-source-libraries
    ], featured
    assert_includes home, "All #{slugs.size} essays"
    assert_includes home, 'href="/resume.pdf"'
    assert_includes home, "getting lost in music"
    refute_match(/podcast/i, home)
  end

  def test_home_hero_leads_with_the_company
    hero = page("index.html")[%r{<section class="hero">.*?</section>}m]
    assert_includes hero, '<p class="label">Co-founder &amp; CTO, <a href="https://inferadb.com">InferaDB</a></p>'
    assert_includes hero, "Authorization at scale is a <em>database problem</em>."
    assert_includes hero, 'co-founder and CTO of <a href="https://inferadb.com">InferaDB</a>'
    assert_includes hero, "I also advise Fortune 500 enterprises on modernizing their identity and authorization."
    refute_includes hero, "Anthropic Identity"
    actions = hero[%r{<p class="cta">.*?</p>}m].scan(/href="([^"]+)"/).flatten
    assert_equal ["https://inferadb.com", "/writing"], actions
  end

  def test_home_closes_on_the_ask
    home = page("index.html")
    assert_equal 2, home.scan("<blockquote").size
    assert_includes home, "Ryan O’Sullivan"
    assert_includes home, "Adam McGrath"
    assert_includes home, ">Work with me</h2>"
    assert_equal %w[InferaDB Advising Speaking], home.scan(%r{<div>\s*<h3>([^<]+)</h3>}).flatten
    assert_includes home, "mailto:hello@evansims.com?subject=InferaDB"
    refute_includes home, "For agents"
    assert_operator home.index("getting lost in music"), :<, home.index("Work with me")
  end

  def test_writing_index_groups_and_order
    html = page("writing.html")
    engineering, life = html.split("Life &amp; craft")
    assert_includes engineering, "<h2>Engineering</h2>"
    assert_equal slugs.sort, toc_links(html).sort
    [engineering, life].each { |part| assert_equal slugs & toc_links(part), toc_links(part) }
    refute_empty toc_links(engineering)
    refute_empty toc_links(life)
    assert_match(/Systems · 7 min/, html)
    assert_includes html, '<p class="lead">What I’ve learned building authorization systems, SDKs, and developer tools. ' \
                          "Shorter essays on work and life follow.</p>"
    assert_equal %w[authorization-is-a-database-problem the-interface-is-the-speed-limit an-agent-needs-its-own-identity],
                 toc_links(engineering).first(3)
    assert_match(%r{<div class="meta">\s*<span class="label">Authorization</span>}, page("authorization-is-a-database-problem.html"))
    assert_match(/Authorization · 3 min/, html)
    assert_includes engineering, '<span class="d">Why a database holding locks across the network hits a throughput ceiling'
    assert_includes page("the-interface-is-the-speed-limit.html"), "<p>More hardware won’t save you.</p>"
  end

  def test_writing_lists_inferadb_articles
    html = page("writing.html")
    section = html[%r{<h2>On the InferaDB blog</h2>.*?</section>}m]
    refute_nil section
    links = section.scan(%r{<a href="(https://inferadb\.com/dispatch/[^"]+)"}).flatten
    assert_equal 12, links.size
    assert_equal links.uniq, links
    assert_includes section, "<span>12 articles</span>"
    assert_includes section, "Why the Model Context Protocol Needs an Authorization Layer"
    assert_match(%r{<span class="m">April 2026 · inferadb\.com}, section)
    assert_match(%r{<span class="m">January 2026 · inferadb\.com}, section)
    assert_operator html.index("On the InferaDB blog"), :>, html.index("<h2>Engineering</h2>")
    assert_operator html.index("On the InferaDB blog"), :<, html.index("Life &amp; craft")
  end

  def test_next_stays_in_its_section
    engineering, life = page("writing.html").split("Life &amp; craft").map { |part| toc_links(part) }
    [engineering, life].each do |group|
      group.each_with_index do |slug, index|
        following = group[(index + 1) % group.size]
        assert_match(%r{<nav class="next"[^>]*>\s*<a href="/#{following}"}, page("#{slug}.html"), slug)
      end
    end
  end

  def test_talks_are_links_not_embeds
    html = page("talks.html")
    ids = html.scan(%r{href="https://www\.youtube\.com/watch\?v=([\w-]+)"}).flatten
    assert_equal %w[I1vhuWceQ3s 9j-LLLTvW34 KmRr1Fz_6Zo KK16e8EPuDU], ids
    refute_includes html, "<iframe"
    assert_includes html, "Coffee &amp; Code: building a Ruby SDK for OpenFGA"
    assert_match(%r{<span class="m">OpenFGA Community Meeting · April 2025 · 10 min · YouTube}, html)
    assert_match(%r{<span class="m">Carla Stabile · February 2025 · 63 min · YouTube}, html)
    assert_match(%r{<span class="m">OpenFGA · August 2024 · 22 min · YouTube}, html)
    assert_equal 2, html.scan('<span class="d">').size
    refute_match(/views/i, html[%r{<ul class="talks".*?</ul>}m])
    assert_match(%r{<a href="mailto:[^"?]+\?subject=Speaking">Email me about speaking}, html)
  end

  def test_removed_and_added_pages
    refute File.exist?(File.join(OUT, "videos.html"))
    refute File.exist?(File.join(OUT, "podcast.html"))
    not_found = page("404.html")
    assert_match(%r{<main id="main">.*href="/".*href="/writing".*</main>}m, not_found)
  end

  def test_canonical_urls_are_extensionless
    assert_includes page("writing.html"), %(<link rel="canonical" href="https://evansims.com/writing">)
    assert_includes page("talks.html"), %(<link rel="canonical" href="https://evansims.com/talks">)
  end
end

class AgentSurfaceTest < Minitest::Test
  include SiteHelpers

  def raw_body(slug)
    split_front_matter(File.read(File.join(DOCS, "_essays/#{slug}.md")))[1]
  end

  def build_again
    ok, log, out = jekyll_build(DOCS)
    flunk(log) unless ok
    out
  end

  def json_ld(html)
    html.scan(%r{<script type="application/ld\+json">(.*?)</script>}m).flatten.map { |block| JSON.parse(block) }
  end

  def test_markdown_copies
    slugs.each do |slug|
      copy = page("#{slug}.md")
      refute_match(/\A---/, copy, slug)
      assert_match(%r{\n---\n\nAuthor: Evan Sims\nSource: https://evansims\.com/#{slug}\n?\z}, copy, slug)
      assert_includes copy, raw_body(slug).strip, slug
    end
    assert_match(/\A# Things I Believe\n\n> What I hold to/, page("beliefs.md"))
    assert_match(/\A# Both Directions Kill You\n\nThere is no middle\./, page("both-directions-kill-you.md"))
    assert_equal 1, page("both-directions-kill-you.md").scan("There is no middle.").size
  end

  def test_essay_links_to_its_markdown
    html = page("feedback.html")
    assert_includes html, %(<link rel="alternate" type="text/markdown" href="/feedback.md">)
    assert_match(%r{<div class="meta">.*href="/feedback\.md">Markdown</a>}m, html)
  end

  def test_llms_txt
    text = page("llms.txt")
    assert text.start_with?("# Evan Sims\n\n> ")
    ["## Engineering", "## Life & craft", "## Elsewhere"].each { |heading| assert_includes text, heading }
    assert_includes text, "- Since 2025: [InferaDB](https://inferadb.com), Co-founder & CTO."
    assert_includes text, "- Since 2026: [Anthropic Identity](https://anthropicidentity.com/), Principal software architect."
    assert_includes text, "- 2024–25: [Okta](https://www.okta.com), Staff software engineer · OpenFGA founding engineer."
    links = text.scan(%r{\]\((https://evansims\.com/[^)]+\.md)\)}).flatten
    assert_equal slugs.sort, links.map { |link| File.basename(link, ".md") }.sort
    assert_includes text, "- [Don't Defend. Explain.](https://evansims.com/feedback.md): How to answer an angry developer in public"
    full = page("llms-full.txt")
    assert full.start_with?("# Evan Sims\n\n> ")
    slugs.each { |slug| assert_includes full, "Source: https://evansims.com/#{slug}" }
  end

  def test_feed_is_valid_and_stable
    feed = REXML::Document.new(page("feed.xml"))
    assert_equal "http://www.w3.org/2005/Atom", feed.root.namespace
    entries = feed.root.get_elements("entry")
    assert_equal slugs.size, entries.size
    stamps = entries.map { |entry| entry.elements["updated"].text }
    stamps.each { |stamp| assert_match(/\A\d{4}-\d\d-\d\dT00:00:00Z\z/, stamp) }
    assert_equal stamps.max, feed.root.elements["updated"].text
    assert_equal stamps.sort.reverse, stamps
    assert_includes entries.map { |entry| entry.elements["title"].text }, "Don't Defend. Explain."
    assert_equal File.binread(File.join(OUT, "feed.xml")), File.binread(File.join(build_again, "feed.xml"))
  end

  def test_sitemap_and_robots
    locations = REXML::Document.new(page("sitemap.xml")).root.get_elements("url/loc").map(&:text)
    assert_equal slugs.size + 3, locations.size
    assert_includes locations, "https://evansims.com/"
    assert_includes locations, "https://evansims.com/feedback"
    robots = page("robots.txt")
    assert_includes robots, "Sitemap: https://evansims.com/sitemap.xml"
    refute_match(%r{^Disallow: /\s*$}, robots)
  end

  def test_json_ld
    person = json_ld(page("index.html")).find { |block| block["@type"] == "Person" }
    assert_equal "InferaDB", person["worksFor"]["name"]
    assert_equal "Anthropic Identity", person["affiliation"]["name"]
    assert_equal "https://anthropicidentity.com/", person["affiliation"]["url"]
    assert_equal 4, person["sameAs"].size
    html_pages.each_value { |html| json_ld(html) }
    post = json_ld(page("docs.html")).find { |block| block["@type"] == "BlogPosting" }
    assert_equal "Documentation", post["headline"]
    assert_includes post["description"], %(what "great" means now)
    assert_kind_of Integer, post["wordCount"]
    refute post.key?("datePublished")
    refute post.key?("dateModified")
    assert_empty json_ld(page("writing.html"))
  end
end
