defmodule Shorty.Store do
  use Agent

  alias Shorty.Url

  def start_link(_opts) do
    Agent.start_link(fn -> %{count: 0, urls: %{}} end, name: __MODULE__)
  end

  def put(long_url) do
    calling_pid = self()

    Agent.update(__MODULE__, fn %{count: count, urls: urls} = store ->
      url = Url.new(count, long_url)
      send(calling_pid, {:url_data, long_url, url})
      %{ store | count: count + 1, urls: Map.put(urls, url.id, url) }
    end)

    receive do
      {:url_data, ^long_url, url} -> url
    end
  end

  def put(long_url, id) do
    url = Url.new(id, long_url)

    Agent.update(__MODULE__, fn %{count: count, urls: urls} = store ->
      %{ store | count: count + 1, urls: Map.put(urls, id, url) }
    end)

    url
  end

  def put_visit(id, datetime) do
    Agent.update(__MODULE__, fn %{urls: %{^id => url} = urls} = store ->
      url_with_visit = %{ url | visits: [ datetime | url.visits ] }
      updated_urls = Map.put(urls, id, url_with_visit)
      %{ store | urls: updated_urls }
    end)
  end

  def get_url(id) when is_integer(id) do
    Agent.get(__MODULE__, fn %{urls: urls} -> Map.get(urls, id) end)
  end
end
