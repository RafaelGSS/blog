defmodule Blog.Services.MarkdownService do
  def parse_as_html(markdown) do
    Earmark.as_html!(markdown)
  end
end
