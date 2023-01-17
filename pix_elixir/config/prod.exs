import Config

config :nerves, :firmware, rootfs_overlay: ["rootfs_overlay"]

config :tzdata, :autoupdate, :disabled
config :display, output: Matrix

config :logger, backends: [
  :console,
  RingLogger,
  {LoggerFileBackend, :error_log}
]
config :logger, RingLogger, max_size: 10_000

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "/root/error.log",
  level: :error

config :shoehorn,
  init: [:nerves_runtime, :nerves_pack],
  app: Mix.Project.config()[:app]

config :mdns_lite,
  # The `host` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  mdns_lite also advertises
  # "nerves.local" for convenience. If more than one Nerves device is on the
  # network, delete "nerves" from the list.

  host: [:hostname, "pix"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]
