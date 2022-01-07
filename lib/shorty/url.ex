defmodule Shorty.Url do
  defstruct [:id, :long_url, :sid, visits: []]

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

  def id_from_sid(sid) do
    String.to_integer(sid, @base)
  end

  def sid_from_id(id) do
    Integer.to_string(id, @base)
  end

  def new(id, long_url) do
    %__MODULE__{id: id, long_url: long_url, sid: sid_from_id(id)}
  end

  def last_visit(%{ visits: [ last_visit | _rest ] }), do: last_visit

  def last_visit(%{ visits: [] }), do: nil

  def num_visits(%{visits: visits}), do: Enum.count(visits)
end
