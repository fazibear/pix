use Mix.Config

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
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "pix.local",
  node_name: :pix,
  node_host: :mdns_domain
