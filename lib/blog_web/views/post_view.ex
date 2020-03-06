defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def title("show.html", %{ post: post }), do: post.title
end
