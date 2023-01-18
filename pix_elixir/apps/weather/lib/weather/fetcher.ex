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
    json = get!("/weather")
   %{
      temp: get_temp(json.body),
      symbol: get_symbol(json.body)
    }
  end

  def get_temp(json) do
    json
    |> Map.get("main")
    |> Map.get("temp")
    |> round()
    |> Integer.to_string()
    |> String.pad_leading(3, " ")
  end

  def get_symbol(json) do
    json
    |> Map.get("weather")
    |> List.first()
    |> Map.get("icon")
  end
end
