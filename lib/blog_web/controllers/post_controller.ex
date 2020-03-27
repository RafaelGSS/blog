defmodule BlogWeb.PostController do
  use BlogWeb, :controller
  alias Blog.Posts.PostsManager

  def index(conn, _params) do
    render conn, "index.html", posts: PostsManager.all_posts
  end

  def show(conn, %{"slug" => slug}) do
    case PostsManager.get_by_slug(slug) do
      {:ok, post} -> render conn, "show.html", post: post
      {:not_found, nil} -> not_found(conn)
    end
  end

  def search(conn, %{"tag" => tag}) do
    case PostsManager.get_by_tags([tag]) do
      {:ok, posts} -> render conn, "index.html", posts: posts
      {:not_found, nil} -> not_found(conn)
    end
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(BlogWeb.ErrorView, "404.html")
  end
end
