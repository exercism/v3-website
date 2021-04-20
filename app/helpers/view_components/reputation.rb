module ViewComponents
  class Reputation < ViewComponent
    def initialize(reputation, size: nil, flashy: false)
      super()

      @reputation = reputation
      @size = size
      @flashy = flashy
    end

    def to_s
      css_classes = []
      css_classes << (flashy ? "c-primary-reputation" : "c-reputation")
      css_classes << "--#{size}" if size

      tag.div(class: css_classes.join(" "), 'aria-label': "#{reputation} reputation") do
        flashy ? tag.div(inner, class: "--inner") : inner
      end
    end

    private
    attr_reader :reputation, :size, :flashy

    def inner
      icon(:reputation, "Reputation") + tag.span(reputation)
    end
  end
end
