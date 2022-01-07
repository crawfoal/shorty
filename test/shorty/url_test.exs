defmodule Shorty.UrlTest do
  use ExUnit.Case, async: true

  alias Shorty.Url

  describe "short_url/1" do
    # this might be a good place for property based testing?
    test "it returns a url w/ base 36 encoded id as the path" do
      url = %Url{id: 101, long_url: "http://host.com/some-really-long-path"}
      assert String.match?(Url.short_url(url), ~r/2T$/)
    end
  end

  describe "id_from_short_url/1" do
    test "it returns the id from the path" do
      assert 101 = Url.id_from_short_url("http://host.com/2T")
    end
  end
end
