# frozen_string_literal: true

require "cgi"
require "date"
require "digest"
require "fileutils"
require "open3"
require "tmpdir"
require "yaml"

module OgCards
  DOCS = File.expand_path("../docs", __dir__)
  TEMPLATE = File.join(DOCS, "_og/card.html")
  MANIFEST = File.join(DOCS, "_data/og.yml")
  CARDS = File.join(DOCS, "assets/og")
  FONTS = File.join(DOCS, "assets/fonts")
  CHROME = ENV.fetch("CHROME", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

  module_function

  def essays
    Dir[File.join(DOCS, "_essays/*.md")].sort.map do |path|
      front = YAML.safe_load(File.read(path, encoding: "UTF-8")[/\A---\n(.*?)\n---\n/m, 1], permitted_classes: [Date, Time])
      { slug: File.basename(path, ".md"), title: front.fetch("title").to_s, topic: front.fetch("topic").to_s }
    end
  end

  def size_for(title)
    return 96 if title.length <= 18
    return 84 if title.length <= 36

    76
  end

  def heading_style(title)
    "font-size: #{size_for(title)}px; text-wrap: balance"
  end

  def digest(title, topic)
    Digest::SHA256.hexdigest([File.read(TEMPLATE, encoding: "UTF-8"), title, topic, heading_style(title)].join("\0"))[0, 10]
  end

  def smart(text)
    text.gsub(/(\w)'(\w)/, "\\1\u2019\\2").gsub(/"([^"]*)"/, "\u201C\\1\u201D")
  end

  def html_for(title, topic)
    File.read(TEMPLATE, encoding: "UTF-8")
        .gsub("../assets/fonts", "file://#{FONTS}")
        .sub(%r{<p class="label">.*?</p>}m, %(<p class="label">#{CGI.escapeHTML(topic)}</p>))
        .sub(%r{<h1>.*?</h1>}m, %(<h1 style="#{heading_style(title)}">#{CGI.escapeHTML(smart(title))}</h1>))
  end

  def render(slug, title, topic)
    Dir.mktmpdir("og") do |dir|
      page = File.join(dir, "card.html")
      File.write(page, html_for(title, topic))
      target = File.join(CARDS, "#{slug}.png")
      log, = Open3.capture2e(
        CHROME, "--headless", "--disable-gpu", "--hide-scrollbars", "--allow-file-access-from-files",
        "--force-device-scale-factor=1", "--window-size=1200,630", "--screenshot=#{target}", "file://#{page}"
      )
      abort("#{slug}: Chrome did not write a card\n#{log}") unless File.size?(target)
    end
  end

  def run(all: false)
    FileUtils.mkdir_p(CARDS)
    known = File.exist?(MANIFEST) ? YAML.load_file(MANIFEST) || {} : {}
    current = {}
    essays.each do |essay|
      slug = essay[:slug]
      current[slug] = digest(essay[:title], essay[:topic])
      next if !all && known[slug] == current[slug] && File.exist?(File.join(CARDS, "#{slug}.png"))

      render(slug, essay[:title], essay[:topic])
      puts "rendered #{slug}"
    end
    Dir[File.join(CARDS, "*.png")].each do |path|
      next if current.key?(File.basename(path, ".png"))

      File.delete(path)
      puts "removed #{File.basename(path)}"
    end
    File.write(MANIFEST, current.sort.map { |slug, value| %(#{slug}: "#{value}"\n) }.join)
    puts "#{current.size} cards current"
  end
end

OgCards.run(all: ARGV.include?("--all")) if $PROGRAM_NAME == __FILE__
