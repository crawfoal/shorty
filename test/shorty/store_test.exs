defmodule Shorty.StoreTest do
  use ExUnit.Case, async: true

  alias Shorty.Store

  describe "put/2" do
    test "stores url by id" do
      long_url = "http://host.com/some-long-path"
      assert Store.get_url(999) == nil

      assert 999 = Store.put(long_url, 999).id
      assert ^long_url = Store.get_url(999).long_url
    end
  end
end
