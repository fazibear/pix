# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
use Mix.Config
# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

import_config "secrets.exs"
import_config "../apps/*/config/config.exs"

# config :firmware, target: Mix.target()
config :tesla, adapter: Tesla.Adapter.Hackney
config :weather,
  units: "metric",
  query: "Warsaw,pl",
  key: Application.get_env(:secrets, :weather_omw_key)

config :bit_bay,
  ticker: ["BTCPLN", "ETHPLN"],
  wallet: Application.get_env(:secrets, :wallet)

case Mix.target() do
  :host -> "host.exs"
  _ -> "target.exs"
end |> import_config()
