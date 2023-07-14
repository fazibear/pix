defmodule Display.Mixfile do
  use Mix.Project

  def project do
    [
      app: :display,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Display.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps(:dev) do
    [
      {:terminal, in_umbrella: true},
    ]
  end

  defp deps(:prod) do
    [
      {:matrix, in_umbrella: true},
    ]
  end
end
