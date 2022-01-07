defmodule Shorty.Urls do
  alias Shorty.{Store, Url}

  def create(long_url) do
    Store.put(long_url)
  end

  def find_by_short_url(short_url) do
    url =
      short_url
      |> Url.id_from_short_url()
      |> Store.get_url()

    url.long_url
  end

  def find_by_sid(sid) do
    Url.id_from_sid(sid)
    |> Store.get_url()
  rescue
    ArgumentError -> nil
  end

  def record_visit(url, datetime) do
    Store.put_visit(url.id, datetime)
  end
end
