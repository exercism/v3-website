class ParseMarkdown
  include Mandate

  # TODO: This needs fixing in mandate but I don't know
  # how to do it without breaking hashes passed as the
  # last argument
  def self.call(*args, **kwargs)
    new(*args, **kwargs).()
  end

  def initialize(text, nofollow_links: false)
    @text = text.to_s
    @nofollow_links = nofollow_links
  end

  def call
    return "" if text.blank?

    sanitized_html
  end

  private
  attr_reader :text, :nofollow_links

  def sanitized_html
    @sanitized_html ||= Loofah.fragment(raw_html).scrub!(:escape).to_s
  end

  def raw_html
    @raw_html ||= begin
      renderer = Renderer.new(options: [:UNSAFE], nofollow_links: nofollow_links)
      html = CommonMarker.render_doc(
        preprocessed_text,
        :DEFAULT,
        %i[table tagfilter strikethrough]
      )
      renderer.render(html)
    end
  end

  def preprocessed_text
    @preprocessed_text ||=
      text.gsub(/^`{3,}(.*?)`{3,}\s*$/m) { "\n#{$&}\n" }
  end

  class Renderer < CommonMarker::HtmlRenderer
    def initialize(options:, nofollow_links: false)
      super(options: options)
      @nofollow_links = nofollow_links
    end

    private
    attr_reader :nofollow_links

    def link(node)
      out('<a href="', node.url.nil? ? '' : escape_href(node.url), '" target="_blank"')
      out(' title="', escape_html(node.title), '"') if node.title.present?
      out(' rel="nofollow"') if nofollow_links
      out('>', :children, '</a>')
    end

    def code_block(node)
      block do
        out("<pre#{sourcepos(node)}><code")
        if node.fence_info.present?
          out(' class="language-', node.fence_info.split(/\s+/)[0], '">')
        else
          out(' class="language-plain">')
        end
        out(escape_html(node.string_content))
        out('</code></pre>')
      end
    end
  end
end
