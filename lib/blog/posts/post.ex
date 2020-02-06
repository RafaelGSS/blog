defmodule Blog.Posts.Post do
  defstruct title: nil, date: nil, text: nil, intro: nil, slug: nil, tags: nil

  alias Blog.Services.MarkdownService

  def compile(file) do
    post = %Blog.Posts.Post{
      slug: file_to_slug(file)
    }

    Path.join(["priv/posts", file])
    |> File.read!
    |> split
    |> extract(post)
  end

  defp file_to_slug(file) do
    String.replace(file, ~r/\.md$/, "")
  end

  defp split(data) do
    [frontmatter, markdown] = String.split(data, ~r/\n-{3,}\n/, parts: 2)
    {parse_yaml(frontmatter), MarkdownService.parse_as_html(markdown)}
  end

  defp parse_yaml(yaml) do
    [parsed] = :yamerl_constr.string(yaml)
    parsed
  end

  defp extract_intro(content) do
    content
    |> HtmlSanitizeEx.strip_tags()
    |> String.slice(0..300)
  end

  defp extract({props, content}, post) do
    %Blog.Posts.Post{post |
      title: get_prop(props, "title"),
      date: Timex.parse!(get_prop(props, "date"), "{ISO:Extended}"),
      intro: extract_intro(content),
      tags: String.split(get_prop(props, "tags"), ","),
      text: content}
  end

  defp get_prop(props, key) do
    case :proplists.get_value(String.to_charlist(key), props) do
      :undefined -> nil
      x -> to_string(x)
    end
  end
end
