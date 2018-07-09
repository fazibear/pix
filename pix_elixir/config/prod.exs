use Mix.Config

config :tzdata, :autoupdate, :disabled
config :display, output: Matrix

config :logger, backends: [
  {LoggerFileBackend, :error_log},
  RingLogger
]
config :logger, RingLogger, max_size: 10_000

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "/root/error.log",
  level: :error

config :shoehorn,
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]
