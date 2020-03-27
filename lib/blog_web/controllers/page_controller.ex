defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def about(conn, _params) do
    render conn, "about.html"
  end
end
