defmodule BlogWeb.PageView do
  use BlogWeb, :view

  def relative_date(date) do
    Timex.Format.DateTime.Formatters.Relative.lformat!(date, "{relative}", "Brazil/East")
  end
end
