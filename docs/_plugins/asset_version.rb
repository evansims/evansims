# frozen_string_literal: true

require "digest"

Jekyll::Hooks.register :site, :post_read do |site|
  stylesheet = File.join(site.source, "assets/css/site.css")
  site.config["css_version"] = Digest::SHA256.file(stylesheet).hexdigest[0, 10]
end
