defmodule Weather.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      worker(Weather, [nil])
      # Starts a worker by calling: Weather.Worker.start_link(arg)
      # {Weather.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Weather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
