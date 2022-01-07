defmodule Shorty.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded], pass: ["text/*"]
  plug :dispatch

  alias Shorty.Urls

  @template_dir "lib/shorty/templates"

  get "/" do
    render(conn, "index.html")
  end

  post "/urls" do
    long_url = conn.body_params["long_url"]
    short_url = Urls.create(long_url)
    conn
    |> put_status(201)
    |> render("urls/show.html", [long_url: long_url, short_url: short_url])
  end

  get "/:sid" do
    case Urls.find_by_sid(sid) do
      nil ->
        send_resp(conn, 404, "oops")
      long_url ->
        html = Plug.HTML.html_escape(long_url)
        body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

        conn
        |> put_resp_header("location", long_url)
        |> send_resp(303, body)
    end
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
