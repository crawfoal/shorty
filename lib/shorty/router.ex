defmodule Shorty.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded], pass: ["text/*"]
  plug :dispatch

  alias Shorty.{ Url, Urls }

  @template_dir "lib/shorty/templates"

  get "/" do
    render(conn, "index.html")
  end

  post "/urls" do
    long_url = conn.body_params["long_url"]
    short_url = Urls.create(long_url) |> Url.short_url()
    conn
    |> put_status(201)
    |> render("urls/show.html", [long_url: long_url, short_url: short_url])
  end

  get "/:sid/stats" do
    case Urls.find_by_sid(sid) do
      nil ->
        send_resp(conn, 404, "not found")
      url ->
        render(conn, "urls/stats.html", [url: url])
    end
  end

  get "/:sid" do
    case Urls.find_by_sid(sid) do
      nil ->
        send_resp(conn, 404, "not found")
      url ->
        Urls.record_visit(url, DateTime.utc_now())

        html = Plug.HTML.html_escape(url.long_url)
        body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

        conn
        |> put_resp_header("location", url.long_url)
        |> send_resp(303, body)
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
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
