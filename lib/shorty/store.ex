defmodule Shorty.Store do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, urls: %{}} end, name: __MODULE__)
  end

  def put(url) do
    Agent.get(__MODULE__, fn %{count: count} -> put(url, count + 1) end)
  end

  def put(url, id) do
    Agent.update(__MODULE__, fn %{count: count, urls: urls} = store ->
      %{ store | count: count + 1, urls: Map.put(urls, id, url) }
    end)
  end

  def get_url(id) when is_integer(id) do
    Agent.get(__MODULE__, fn %{urls: urls} -> Map.get(urls, id) end)
  end
end
