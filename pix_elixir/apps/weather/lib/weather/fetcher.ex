defmodule Weather.Fetcher do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.openweathermap.org/data/2.5"
  plug Tesla.Middleware.DecodeJson
  plug Tesla.Middleware.Query, [
    q: Application.fetch_env!(:weather, :query),
    units: Application.fetch_env!(:weather, :units),
    appid: Application.fetch_env!(:weather, :owm_key)
  ]

  def fetch() do
    get("/weather")
  end
end
