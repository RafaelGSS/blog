defmodule BlogWeb.PageView do
  use BlogWeb, :view

  def relative_date(date) do
    Timex.Format.DateTime.Formatters.Relative.lformat!(date, "{relative}", "Brazil/East")
  end

  def title("index.html", _assigns), do: "Rafael Gonzaga - Index"
  def title("about.html", _assigns), do: "Rafael Gonzaga - Sobre mim"
end
