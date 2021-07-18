defmodule BlogWeb.RSSController do
  use BlogWeb, :controller

  def index(conn, _params) do
    redirect(conn, external: "https://fetchrss.com/rss/60f45681e6bea473526669e360f456bd068fbd12c45c8cc2.xml")
  end
end
