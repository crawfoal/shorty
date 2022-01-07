defmodule Shorty.StoreTest do
  use ExUnit.Case, async: true

  alias Shorty.Store

  setup do
    {:ok, store} = Store.start_link([])
    %{store: store}
  end

  describe "put/2" do
    test "stores url by id", %{store: store} do
      long_url = "http://host.com/some-long-path"
      assert Store.get_url(store, 999) == nil

      Store.put(store, long_url, 999)
      assert ^long_url = Store.get_url(store, 999)
    end
  end
end
