defmodule BinaryClock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      worker(BinaryClock, [nil])
      # Starts a worker by calling: BinaryClock.Worker.start_link(arg)
      # {BinaryClock.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BinaryClock.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
