use Mix.Config

config :logger, backends: [RingLogger]
config :logger, RingLogger, max_size: 10_000

config :shoehorn,
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]
