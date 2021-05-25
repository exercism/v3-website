class Ansi::RenderHTML
  include Mandate

  initialize_with :text

  def call
    return nil if text.nil?

    Ansi::To::Html.new(sanitized_text).to_html
  end

  private
  def sanitized_text
    # The ansi-to-html library does not support unicode escape sequence
    # See https://github.com/rburns/ansi-to-html/issues/48
    text.gsub("\e\[K", '')
  end
end
