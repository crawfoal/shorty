defmodule Shorty.Store do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, urls: %{}} end, name: __MODULE__)
  end

  def put(url) do
    calling_pid = self()

    Agent.update(__MODULE__, fn %{count: count, urls: urls} = store ->
      send(calling_pid, {:url_id, url, count})
      %{ store | count: count + 1, urls: Map.put(urls, count, url) }
    end)

    receive do
      {:url_id, ^url, id} -> id
    end
  end

  def put(url, id) do
    Agent.update(__MODULE__, fn %{count: count, urls: urls} = store ->
      %{ store | count: count + 1, urls: Map.put(urls, id, url) }
    end)

    id
  end

  def get_url(id) when is_integer(id) do
    Agent.get(__MODULE__, fn %{urls: urls} -> Map.get(urls, id) end)
  end
end
