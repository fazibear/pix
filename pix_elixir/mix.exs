defmodule Pix.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      # start_permanent: Mix.env() == :prod,
      deps: [],
      aliases: [run: "run --no-halt"]
    ]
  end
end
