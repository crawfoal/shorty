defmodule Shorty.Url do
  defstruct [:id, :long_url, :short_url]

  @base 36
  @host "http://localhost:4001/"

  def short_url(url) do
    @host <> Integer.to_string(url.id, @base)
  end

  def id_from_short_url(short_url) do
    "/" <> sid = URI.parse(short_url).path
    String.to_integer(sid, @base)
  end

  def short_url_from_id(id) do
    @host <> Integer.to_string(id, @base)
  end
end
