# frozen_string_literal: true

require "date"

module Essays
  WORDS_PER_MINUTE = 230.0
  REQUIRED = %w[title topic updated].freeze
  LONGEST_DERIVED_DESCRIPTION = 160
  NOT_A_PARAGRAPH = /\A(?:#|>|[-*+]\s|\d+[.)]\s|<|!\[|```|~~~|\||(?:-{3,}|\*{3,}|_{3,})\s*\z)|\n\s*(?:=+|-+)\s*\z/

  module_function

  def prepare(site)
    docs = site.collections["essays"].docs
    listing = Array(site.data["writing"])
    order = listed_slugs(listing)
    featured = listing.select { |item| item["featured"] }.map { |item| item["slug"] }
    present = docs.map { |doc| slug_of(doc) }
    cards = site.data["og"] || {}

    (order - present).each { |slug| stop(absent(site, slug)) }

    docs.each do |doc|
      slug = slug_of(doc)
      doc.data["markdown"] = doc.content.to_s.gsub("\r\n", "\n")
      validate(doc, slug, order)
      describe(doc, slug)
      doc.data["section"] = section_of(site, doc, slug)
      doc.data["order"] = order.index(slug)
      doc.data["featured"] = featured.include?(slug)
      doc.data["words"] = doc.data["markdown"].split.size
      doc.data["minutes"] = [(doc.data["words"] / WORDS_PER_MINUTE).ceil, 1].max
      doc.data["markdown_url"] = "/#{slug}.md"
      doc.data["og_image"] = "/assets/og/#{slug}.png?v=#{cards[slug]}" if cards[slug]
    end

    docs.sort_by! { |doc| doc.data["order"] }
    docs.group_by { |doc| doc.data["section"] }.each_value do |group|
      group.each_with_index do |doc, index|
        following = group[(index + 1) % group.size]
        doc.data["next_url"] = following.url
        doc.data["next_title"] = following.data["title"]
      end
    end
  end

  def slug_of(doc)
    doc.basename_without_ext
  end

  def listed_slugs(listing)
    slugs = listing.each_with_index.map do |item, index|
      slug = item.is_a?(Hash) ? item["slug"].to_s.strip : ""
      stop("_data/writing.yml: entry #{index + 1} has no slug") if slug.empty?
      slug
    end
    repeated = slugs.find { |slug| slugs.count(slug) > 1 }
    stop("#{repeated}: listed more than once in _data/writing.yml") if repeated
    slugs
  end

  def absent(site, slug)
    if File.exist?(File.join(site.collections["essays"].directory, "#{slug}.md"))
      "#{slug}: listed in _data/writing.yml but not built; check for `published: false` in its front matter"
    else
      "#{slug}: listed in _data/writing.yml but _essays/#{slug}.md does not exist"
    end
  end

  def validate(doc, slug, order)
    declared = front_matter(doc)
    REQUIRED.each { |key| stop("#{slug}: missing #{key}") if declared[key].to_s.strip.empty? }
    stop("#{slug}: updated must be a date like 2026-04-29") unless doc.data["updated"].is_a?(Date)
    stop("#{slug}: not listed in _data/writing.yml") unless order.include?(slug)
  end

  def front_matter(doc)
    block = File.read(doc.path, encoding: "UTF-8")[Jekyll::Document::YAML_FRONT_MATTER_REGEXP, 1].to_s
    loaded = YAML.safe_load(block, permitted_classes: [Date, Time])
    loaded.is_a?(Hash) ? loaded : {}
  end

  def section_of(site, doc, slug)
    topic = doc.data["topic"]
    key, = site.data["topics"].find { |_, group| group["topics"].include?(topic) }
    stop(%(#{slug}: topic "#{topic}" is not in _data/topics.yml)) unless key
    key
  end

  def describe(doc, slug)
    explicit = !doc.data["description"].to_s.strip.empty?
    doc.data["description_explicit"] = explicit
    return if explicit

    opening = doc.data["markdown"].strip.split(/\n{2,}/).first.to_s.strip
    stop("#{slug}: does not open with a plain paragraph, so it needs a description") if opening.match?(NOT_A_PARAGRAPH)
    derived = plain(opening)
    if derived.length > LONGEST_DERIVED_DESCRIPTION
      stop("#{slug}: opens with a paragraph over #{LONGEST_DERIVED_DESCRIPTION} characters, " \
           "so it needs a description (and probably `lede: false`)")
    end
    doc.data["description"] = derived
  end

  def plain(text)
    text
      .gsub(/\[([^\]]+)\]\([^)]*\)/, '\1')
      .gsub(/(\*\*|__)(.+?)\1/, '\2')
      .gsub(/\*(.+?)\*/, '\1')
      .gsub(/(?<!\w)_(.+?)_(?!\w)/, '\1')
      .gsub(/`([^`]+)`/, '\1')
      .gsub(/\s+/, " ")
      .strip
  end

  def stop(message)
    raise Jekyll::Errors::FatalException, "Essays: #{message}", []
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  Essays.prepare(site)
end
