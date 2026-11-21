# frozen_string_literal: true

module AgentFiles
  module_function

  def write(site)
    essays = site.collections["essays"].docs
    copies = essays.map { |doc| copy_of(site, doc) }
    essays.zip(copies).each do |doc, copy|
      File.write(File.join(site.dest, "#{doc.basename_without_ext}.md"), copy)
    end
    preface = "# #{site.config["title"]}\n\n> #{site.config["description"]}\n\n"
    File.write(File.join(site.dest, "llms-full.txt"), preface + copies.join("\n"))
  end

  def copy_of(site, doc)
    parts = ["# #{doc.data["title"]}"]
    parts << "> #{doc.data["description"]}" if doc.data["description_explicit"]
    parts.push(doc.data["markdown"].strip, "---", "Source: #{site.config["url"]}#{doc.url}")
    "#{parts.join("\n\n")}\n"
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  AgentFiles.write(site)
end
