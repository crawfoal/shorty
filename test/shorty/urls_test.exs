defmodule Shorty.UrlsTest do
  use ExUnit.Case, async: true

  alias Shorty.{ Url, Urls }

  describe "create/1" do
    test "it persists the url (in memory) along with a short url" do
      long_url = "http://host.com/some-really-long-path"
      url = Urls.create(long_url)
      short_url = Url.short_url(url)
      assert String.match?(short_url, ~r/#{Shorty.server_url()}\w+/)
      assert long_url == Urls.find_by_short_url(short_url)
    end
  end

  describe "record_visit/2" do
    test "visits are tracked in the struct" do
      long_url = "http://host.com/some-really-long-path"
      url = Urls.create(long_url)
      dt = ~N[2021-01-02 12:35:20]

      assert Url.last_visit(url) == nil
      assert Url.num_visits(url) == 0

      Urls.record_visit(url, dt)

      url = Urls.find_by_sid(url.sid)

      assert Url.last_visit(url) == dt
      assert Url.num_visits(url) == 1
    end
  end
end
