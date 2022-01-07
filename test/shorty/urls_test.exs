defmodule Shorty.UrlsTest do
  use ExUnit.Case, async: true

  alias Shorty.Urls

  describe "create/1" do
    test "it persists the url (in memory) along with a short url" do
      long_url = "http://host.com/some-really-long-path"
      short_url = Urls.create(long_url)
      assert String.match?(short_url, ~r/#{Shorty.server_url()}\w+/)
      assert long_url == Urls.find_by_short_url(short_url)
    end
  end
end
