# frozen_string_literal: true

require "minitest/autorun"
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
      next if %w[_site .jekyll-cache].include?(child)

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
    assert_includes home, "try"
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
    assert_match(%r{<div class="meta">.*Systems.*6 min}m, html)
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

  def test_next_wraps
    last = slugs.last
    first = slugs.first
    assert_match(%r{<nav class="next"[^>]*>.*href="/#{first}"}m, page("#{last}.html"))
  end

  def test_print_styles_exist
    assert_includes page("assets/css/site.css"), "@media print"
  end
end
