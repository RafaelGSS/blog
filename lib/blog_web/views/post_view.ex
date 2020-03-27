defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def relative_date(date) do
    Timex.Format.DateTime.Formatters.Relative.lformat!(date, "{relative}", "Brazil/East")
  end

  def title("index.html", _assigns), do: "Rafael Gonzaga - Página Inicial"
  def title("show.html", %{ post: post }), do: post.title
end
