defmodule Shorty.Url do
  defstruct [:id, :long_url]

  @host "http://localhost:4001/"

  def short_url(url) do
    @host <> Integer.to_string(url.id, 36)
  end
end
