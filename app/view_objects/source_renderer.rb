class SourceRenderer
  attr_reader :source_file

  def initialize(source_file)
    @source_file = source_file
  end

  def to_html
    <<-HTML
    <table class="code-block highlight">
      <caption class="code-filename">#{filename}</caption>
      <tbody>#{html_code_with_comments}</tbody>
    </table>
    HTML
  end

  private

  def filename
    source_file.filename
  end

  def html_code_with_comments
    table_rows = source_lines.each_with_index.map do |line, index|
      format_line(index + 1, line)
    end

    sorted_comments.each do |comment|
      table_rows.insert(comment.line_number, format_comment(comment))
    end

    table_rows.join("\n")
  end

  def sorted_comments
    comments.sort_by { |comment| -comment.line_number }
  end

  def comments
    @comments ||= source_file.comments.select do |comment|
      comment.line_number <= source_lines.length
    end
  end

  def source_lines
    html_source_code.split("\n")
  end

  def html_source_code
    @html_source_code ||= formatter.format(lexer.lex(source_file.body)).
      gsub("<pre><code class=\"highlight\">", "").
      gsub("</code></pre>", "")
  end

  def format_line(line_no, line)
    <<-HTML
    <tr class="code-line" data-line-no="#{line_no}">
      <td class="code-line-no">#{line_no}</td>
      <td class="code-line-body">#{line}</td>
    </tr>
    HTML
  end

  def format_comment(comment)
    <<-HTML
    <tr class="code-comment-inline">
      <td colspan="2">
        <div class="code-comment-header">
          <span class="code-username">#{comment.user.username}</span>
          commented on <span class=\"code-timestamp\">
                        #{comment.created_at}
                      </span>
        </div>
        <div class="code-comment-body">
          #{render_safe_markdown(comment.body)}
        </div>
      </td>
    </tr>
    HTML
  end

  def lexer
    @lexer ||= Rouge::Lexer.
      find_fancy(language, source_file.body) || Rouge::Lexers::PlainText
  end

  def formatter
    @formatter ||= Rouge::Formatters::HTML.new
  end

  def language
    File.extname(filename)[1..-1]
  end

  def render_safe_markdown(content)
    Markdown.render_safe(content)
  end
end
