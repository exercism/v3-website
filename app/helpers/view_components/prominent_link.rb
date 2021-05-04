module ViewComponents
  class ProminentLink < ViewComponent
    def initialize(text, url, with_bg: false, external: false)
      @text = text
      @url = url
      @with_bg = with_bg
      @external = external

      super()
    end

    def to_s
      if external
        external_link_to(text, url, class: css_class)
      else
        link_to(url, class: css_class) do
          tag.span(text) + graphical_icon("arrow-right")
        end
      end
    end

    private
    attr_reader :text, :url, :with_bg, :external

    def css_class
      c = ['c-prominent-link']
      c << '--with-bg' if with_bg
      c.join(" ")
    end
  end
end
