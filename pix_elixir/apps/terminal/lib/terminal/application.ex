defmodule Terminal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Terminal, []}
      # Starts a worker by calling: Terminal.Worker.start_link(arg)
      # {Terminal.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Terminal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
