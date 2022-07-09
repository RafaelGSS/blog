defmodule BlogWeb.LayoutView do
  use BlogWeb, :view
  def title(assigns) do
    module = Phoenix.Controller.view_module(assigns.conn)
    template = Phoenix.Controller.view_template(assigns.conn)
    module.title(template, assigns)
  end
end
