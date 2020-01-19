defmodule BlogWeb.PageController do
  use BlogWeb, :controller
  alias Blog.Posts.PostsManager

  def index(conn, _params) do
    render conn, "index.html", posts: PostsManager.all_posts
  end

  def contact(conn, _params) do
    render conn, "contact.html"
  end
end
