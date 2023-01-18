import Config

# # tell logger to load a LoggerFileBackend processes
# config :logger,
#   backends: [{LoggerFileBackend, :error_log}]
#
# # configuration for the {LoggerFileBackend, :error_log} backend
# config :logger, :error_log,
#   path: "logs.log",
#   level: :warn

config :display, output: Terminal
