# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

config :firmware, target: Mix.target()

config :tesla, adapter: Tesla.Adapter.Hackney

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
