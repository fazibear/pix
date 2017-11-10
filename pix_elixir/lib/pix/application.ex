defmodule Pix.Application do
  use Application

  alias Pix.Features

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    features = [
      Features.Clock,
      Features.Random,
    ]

    # Define workers and child supervisors to be supervised
    children = worker_features(features) ++ [
      worker(Pix.Display, [features]),
      worker(Application.fetch_env!(:pix, :output), [nil])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def worker_features(features) do
    import Supervisor.Spec, warn: false
    features
    |> Enum.map(fn f -> worker(f, [nil]) end)
  end
end
