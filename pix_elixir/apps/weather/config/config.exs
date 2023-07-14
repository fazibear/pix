import Config

config :weather,
  units: "metric",
  query: "Warsaw,pl",
  owm_key: Secrets.get!(:openweathermap_api_key)
