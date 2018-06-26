defmodule BitBay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bit_bay,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BitBay.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.0"},
      {:httpotion, "~> 3.0"},

      {:display, in_umbrella: true},
      {:terminal, in_umbrella: true}
    ]
  end
end
