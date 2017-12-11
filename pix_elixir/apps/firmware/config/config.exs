# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

target = System.get_env("MIX_TARGET") || "host"

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

unless target == "host" do
  config :bootloader,
    init: [:nerves_runtime, :nerves_network, :ssh, :nerves_ntp],
    app: Mix.Project.config[:app]

  # ntpd binary to use
  config :nerves_ntp, :ntpd, "/usr/sbin/ntpd"

  # servers to sync time from
  config :nerves_ntp, :servers, [
      "0.pool.ntp.org",
      "1.pool.ntp.org",
      "2.pool.ntp.org",
      "3.pool.ntp.org"
    ]
end

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
