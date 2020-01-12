defmodule Blog.Posts.PostsManager do
  alias Blog.Posts.Post

  def all_posts do
    File.ls!("priv/posts")
    |> Enum.map(&Blog.Posts.Post.compile/1)
  end

  def get_by_slug(slug) do
    posts = all_posts()

    case Enum.find(posts, &(&1.slug == slug)) do
      nil -> {:not_found, nil}
      post -> {:ok, post}
    end
  end
end
