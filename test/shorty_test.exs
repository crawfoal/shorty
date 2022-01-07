defmodule ShortyTest do
  use ExUnit.Case
  doctest Shorty

  test "server_url/1" do
    assert Shorty.server_url() == "http://localhost:4001/"
  end
end
