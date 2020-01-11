defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", posts: [
      %{
        title: "Example of greatest title",
        subtitle: "thursday, january 09, 2020",
        text: "I’ve created a few videos on the topic of effective enterprise testing. I still see a huge importance in this topic in real-world projects. Here are my experiences in testing Enterprise Java projects together with some examples.",
        link: "#"
      }
    ]
  end
end
