defmodule BlogWeb.RSSController do
  use BlogWeb, :controller

  def index(conn, _params) do
    redirect(conn, external: "http://fetchrss.com/rss/6474617bafe4ff34332982826474fd06677a46535867c392.xml")
  end
end
