defmodule BlogWeb.LayoutView do
  use BlogWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def title(assigns) do
    module = Phoenix.Controller.view_module(assigns.conn)
    template = Phoenix.Controller.view_template(assigns.conn)
    module.title(template, assigns)
  end
end
