defmodule Covid.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      worker(Covid, [nil])
      # Starts a worker by calling: Covid.Worker.start_link(arg)
      # {Covid.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Covid.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
