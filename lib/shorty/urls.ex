defmodule Shorty.Urls do
  alias Shorty.{Store, Url}

  def create(long_url) do
    Store.put(long_url)
    |> Url.short_url_from_id()
  end

  def find_by_short_url(short_url) do
    short_url
    |> Url.id_from_short_url()
    |> Store.get_url()
  end
end
