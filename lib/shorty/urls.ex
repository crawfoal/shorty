defmodule Shorty.Urls do
  alias Shorty.{Store, Url}

  def create(long_url) do
    Store.put(long_url)
    |> Url.short_url()
  end

  def find_by_short_url(short_url) do
    url =
      short_url
      |> Url.id_from_short_url()
      |> Store.get_url()

    url.long_url
  end

  def find_by_sid(sid) do
    url =
      Url.id_from_sid(sid)
      |> Store.get_url()

    url.long_url

  rescue
    ArgumentError -> nil
  end
end
