defmodule Blog.Posts.PostsManager do
  alias Blog.Posts.Post

  def sort_post_by_date(postA, postB) do
    Timex.diff(postA.date, postB.date) > 0
  end

  def all_posts do
    File.ls!("priv/posts")
    |> Enum.map(&Post.compile/1)
    |> Enum.sort(&sort_post_by_date/2)
  end

  def get_by_slug(slug) do
    posts = all_posts()

    case Enum.find(posts, &(&1.slug == slug)) do
      nil -> {:not_found, nil}
      post -> {:ok, post}
    end
  end
end
