require "rouge/plugins/redcarpet"

class Markdown
  def self.render(content)
    renderer.render(content)
  end

  def self.render_safe(content)
    Sanitize.fragment(renderer.render(content), sanitizer_config)
  end

  private

  def self.sanitizer_config
    Sanitize::Config.merge(Sanitize::Config::BASIC,
      elements: Sanitize::Config::BASIC[:elements] + ["span"],
      attributes: { "span" => ["class"], "code" => ["class"] })
  end

  def self.renderer
    Redcarpet::Markdown.new(HighlightingRenderer,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true)
  end

  class HighlightingRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
