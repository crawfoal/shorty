defmodule Shorty.Store do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, urls: %{}} end)
  end

  def put(store, url) do
    Agent.get(store, fn %{count: count} -> put(store, url, count + 1) end)
  end

  def put(store, url, id) do
    Agent.update(store, fn %{count: count, urls: urls} = store ->
      %{ store | count: count + 1, urls: Map.put(urls, id, url) }
    end)
  end

  def get_url(store, id) when is_integer(id) do
    Agent.get(store, fn %{urls: urls} -> Map.get(urls, id) end)
  end
end
