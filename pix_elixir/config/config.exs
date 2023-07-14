# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

import_config "secrets.exs"

config :tesla, adapter: Tesla.Adapter.Httpc

for config <- "../apps/*/config/config.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end

IO.puts "Mix target: #{Mix.target()}"

case Mix.target() do
  :host -> "host.exs"
  _ -> "target.exs"
end |> import_config()
