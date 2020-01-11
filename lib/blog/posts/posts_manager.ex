defmodule Blog.Posts.PostsManager do
  alias Blog.Posts.Post

  def all_posts do
    File.ls!("priv/posts")
    |> Enum.map(&Blog.Posts.Post.compile/1)
  end
end
