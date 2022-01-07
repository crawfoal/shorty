defmodule Shorty.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Shorty.{Router, Urls}

  @opts Router.init([])

  test "undefined routes return 404 status" do
    conn = conn(:get, "/not-found")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops"
  end

  test "root route presents template" do
    conn = conn(:get, "/")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert String.match?(conn.resp_body, ~r/What would you like to shorten today\?/)
  end

  test "POST /urls accepts form encoded data and returns short url" do
    conn =
      conn(:post, "/urls", "long_url=https%3A%2F%2Ffoo.bar.com%2Fpath")
      |> put_req_header("content-type", "application/x-www-form-urlencoded")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert String.match?(conn.resp_body, ~r/Great! You can now access/)
    assert String.match?(conn.resp_body, ~r/#{"https://foo.bar.com/path"}/)
    assert String.match?(conn.resp_body, ~r/#{"http://localhost:4001/"}\w+/)
  end

  test "GET /:sid redirects to long url" do
    long_url = "http://host.com/some-really-long-path"
    short_url = Urls.create(long_url)

    conn = conn(:get, URI.parse(short_url).path)

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 303
  end
end
