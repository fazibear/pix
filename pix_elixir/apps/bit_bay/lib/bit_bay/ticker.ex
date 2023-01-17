defmodule BitBay.Ticker do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://bitbay.net/API/Public"
#  plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON

  def type(type) do
    get(type <> "/ticker.json")
    |> inspect()
  end
end
