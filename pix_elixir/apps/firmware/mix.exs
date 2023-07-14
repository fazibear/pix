defmodule Firmware.MixProject do
  use Mix.Project

  @app :firmware
  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :osd32mp1, :x86_64, :grisp2]

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.11"],
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      build_path: "../../_build",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      deps: deps(Mix.env()),
      releases: [{@app, release(Mix.env())}],
      preferred_cli_target: [run: :host, test: :host],
      #      aliases: [run: "run --no-halt"]
    ]
  end

  defp deps(:prod) do
    [
      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},
      {:nerves_time, "~> 0.4", targets: @all_targets},
      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {:nerves_system_rpi, "~> 1.19", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.19", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.19", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.19", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 1.19", runtime: false, targets: :rpi3a},
      {:nerves_system_rpi4, "~> 1.19", runtime: false, targets: :rpi4},
      {:nerves_system_bbb, "~> 2.14", runtime: false, targets: :bbb},
      {:nerves_system_osd32mp1, "~> 0.10", runtime: false, targets: :osd32mp1},
      {:nerves_system_x86_64, "~> 1.19", runtime: false, targets: :x86_64},
      {:nerves_system_grisp2, "~> 0.3", runtime: false, targets: :grisp2},

      {:ring_logger, "~> 0.6"},
    ] ++ other_deps()
  end

  defp deps(_) do
    [
      {:logger_file_backend, "~> 0.0.10"},
    ] ++ other_deps()
  end

  defp other_deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},

      {:shoehorn, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      {:binary_clock, in_umbrella: true},
      {:clock, in_umbrella: true},
      {:space_crab, in_umbrella: true},
      {:weather, in_umbrella: true},
      {:wotd, in_umbrella: true},
      {:year_progress, in_umbrella: true},
      {:ip, in_umbrella: true},
      {:game_of_life, in_umbrella: true},

      #{:covid, in_umbrella: true},
      #{:bit_bay, in_umbrella: true},
    ]
  end

  def release(:prod) do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end

  def release(_) do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      steps: [:assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
