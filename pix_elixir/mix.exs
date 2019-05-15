defmodule Pix.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      # start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: [run: "run --no-halt"]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
