defmodule Shorty.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Shorty.Router

  @opts Router.init([])

  test "undefined routes return 404 status" do
    conn = conn(:get, "/not-found")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops"
  end

  test "root route is defined" do
    conn = conn(:get, "/")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "home"
  end
end
