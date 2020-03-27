defmodule BlogWeb.PageView do
  use BlogWeb, :view

  def title("about.html", _assigns), do: "Rafael Gonzaga - Sobre mim"
end
