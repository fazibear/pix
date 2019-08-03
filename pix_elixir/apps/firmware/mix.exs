defmodule Firmware.MixProject do
  use Mix.Project
  @app :firmware
  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.9",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.0"],
      deps_path: "../../deps/#{@target}",
      build_path: "../../_build/#{@target}",
      config_path: "../../config/config.exs",
      lockfile: "../../mix.lock.#{@target}",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application, do: application(@target)

  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke Firmware.start/2 when running on a target.
  def application("host") do
    [extra_applications: [:logger]]
  end

  def application(_target) do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:nerves, "~> 1.0", runtime: false}] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host"), do: []

  defp deps(target) do
    [
      {:shoehorn, "~> 0.6"},
      {:nerves_runtime, "~> 0.4"},
      {:logger_file_backend, "~> 0.0.1"},
      {:nerves_init_gadget, github: "fazibear/nerves_init_gadget", branch: "discover_ssh"},
      {:nerves_time, "~> 0.2"},
      {:toolshed, "~> 0.2"},

      # pix apps
      {:matrix, in_umbrella: true},
      {:bit_bay, in_umbrella: true},
      {:binary_clock, in_umbrella: true},
      {:clock, in_umbrella: true},
      {:space_crab, in_umbrella: true},
      {:weather, in_umbrella: true},
      {:wotd, in_umbrella: true}
    ] ++ system(target)
  end

  defp system("rpi"), do: [{:nerves_system_rpi, ">= 0.0.0", runtime: false}]
  defp system("rpi0"), do: [{:nerves_system_rpi0, ">= 0.0.0", runtime: false}]
  defp system("rpi2"), do: [{:nerves_system_rpi2, ">= 0.0.0", runtime: false}]
  defp system("rpi3"), do: [{:nerves_system_rpi3, ">= 0.0.0", runtime: false}]
  defp system("bbb"), do: [{:nerves_system_bbb, ">= 0.0.0", runtime: false}]
  defp system("ev3"), do: [{:nerves_system_ev3, ">= 0.0.0", runtime: false}]

  defp system("qemu_arm"),
    do: [{:nerves_system_qemu_arm, ">= 0.0.0", runtime: false}]

  defp system("x86_64"),
    do: [{:nerves_system_x86_64, ">= 0.0.0", runtime: false}]

  defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end
