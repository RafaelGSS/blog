defmodule BlogWeb.PostController do
  use BlogWeb, :controller
  alias Blog.Posts.PostsManager

  def show(conn, %{"slug" => slug}) do
    case PostsManager.get_by_slug(slug) do
      {:ok, post} -> render conn, "show.html", post: post
      {:not_found, nil} -> not_found(conn)
    end
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(BlogWeb.ErrorView, "404.html")
  end
end
