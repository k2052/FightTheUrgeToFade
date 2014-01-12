require 'nokogiri'
class MarkdownExtRenderer < Redcarpet::Render::HTML
  def initialize(options={})
    @footnote_count = 0
    super options
  end

  def paragraph(text)
    footnote_prefix_regex.match(text.strip)
    if footnote_prefix_regex.match(text.strip)
      return footnote(text)
    elsif footnote_regex.match(text)
      text = text.gsub(footnote_regex) do
        @footnote_count += 1
        "<a href='#footnote_#{$1}'><sup>#{@footnote_count}</sup></a>"
      end
    end

    "<p>" + text + "</p>"
  end

  def header(text, header_level)
    text_slug = text.gsub(/\W/, "_").downcase
    "<h#{header_level} id='#{text_slug}'>#{text}</h#{header_level}>"
  end

  def postprocess(full_document)
    doc = Nokogiri::HTML(full_document)
    footnotes_section = doc.at_css 'h2#footnotes'
    footnotes_section = doc.at_css 'h2#anecdotes' unless footnotes_section

    if footnotes_section
      footnotes = Nokogiri::XML::Node.new 'ol', doc
      footnotes['class'] = 'footnotes'
      footnotes_section.add_next_sibling(footnotes)

      doc.css('.footnote').each_with_index do |note|
        note.parent = footnotes
      end
    end

    doc.to_html
  end

  def footnote(text)
    text = text.gsub(footnote_prefix_regex, '')
    "<li class='footnote'><a name='footnote_#{$1}' href='#'></a>#{text}</ol>"
  end

  private
    def footnote_prefix_regex
      /\[\^([^\]]*)\]:\s*/
    end

    def footnote_regex 
      /\[\^([^\]]*)\]/
    end
end
