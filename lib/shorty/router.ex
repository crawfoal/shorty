defmodule Shorty.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded], pass: ["text/*"]
  plug :dispatch

  @template_dir "lib/shorty/templates"

  get "/" do
    render(conn, "index.html")
  end

  post "/urls" do
    long_url = conn.body_params["long_url"]
    #short_url = Urls.create(long_url)
    conn
    |> put_status(201)
    |> render("urls/show.html", [long_url: long_url, short_url: "http://localhost:4001/abc123"])
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp render(%{status: status} = conn, template, assigns \\ []) do
    body =
      @template_dir
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(assigns)

    send_resp(conn, (status || 200), body)
  end
end
