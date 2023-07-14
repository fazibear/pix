defmodule Lastfm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lastfm,
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
      mod: {Lastfm.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:display, in_umbrella: true},
      {:tesla, "~> 1.7.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
