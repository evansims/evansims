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
