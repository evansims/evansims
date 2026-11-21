# frozen_string_literal: true

require "date"

module Essays
  WORDS_PER_MINUTE = 230.0
  REQUIRED = %w[title topic updated].freeze

  module_function

  def prepare(site)
    docs = site.collections["essays"].docs
    listing = site.data["writing"]
    order = listing.map { |item| item["slug"] }
    featured = listing.select { |item| item["featured"] }.map { |item| item["slug"] }
    present = docs.map { |doc| slug_of(doc) }

    (order - present).each do |slug|
      stop("#{slug}: listed in _data/writing.yml but _essays/#{slug}.md does not exist")
    end

    docs.each do |doc|
      slug = slug_of(doc)
      validate(doc, slug, order)
      describe(doc, slug)
      doc.data["section"] = section_of(site, doc, slug)
      doc.data["order"] = order.index(slug)
      doc.data["featured"] = featured.include?(slug)
      doc.data["words"] = doc.content.to_s.split.size
      doc.data["minutes"] = [(doc.data["words"] / WORDS_PER_MINUTE).ceil, 1].max
      doc.data["markdown_url"] = "/#{slug}.md"
    end

    docs.sort_by! { |doc| doc.data["order"] }
    docs.each_with_index do |doc, index|
      following = docs[(index + 1) % docs.size]
      doc.data["next_url"] = following.url
      doc.data["next_title"] = following.data["title"]
    end
  end

  def slug_of(doc)
    doc.basename_without_ext
  end

  def validate(doc, slug, order)
    declared = front_matter(doc)
    REQUIRED.each { |key| stop("#{slug}: missing #{key}") unless declared.key?(key) }
    stop("#{slug}: updated must be a date like 2026-04-29") unless doc.data["updated"].is_a?(Date)
    stop("#{slug}: not listed in _data/writing.yml") unless order.include?(slug)
  end

  def front_matter(doc)
    block = File.read(doc.path, encoding: "UTF-8")[/\A---\n(.*?)\n---\n/m, 1].to_s
    YAML.safe_load(block, permitted_classes: [Date]) || {}
  end

  def section_of(site, doc, slug)
    topic = doc.data["topic"]
    key, = site.data["topics"].find { |_, group| group["topics"].include?(topic) }
    stop(%(#{slug}: topic "#{topic}" is not in _data/topics.yml)) unless key
    key
  end

  def describe(doc, slug)
    explicit = !doc.data["description"].to_s.strip.empty?
    opening = doc.content.to_s.strip.split(/\n{2,}/).first.to_s.strip
    stop("#{slug}: opens with a heading, so it needs a description") if !explicit && opening.start_with?("#")
    doc.data["description_explicit"] = explicit
    doc.data["description"] = plain(opening) unless explicit
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
    Jekyll.logger.abort_with("Essays:", message)
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  Essays.prepare(site)
end
