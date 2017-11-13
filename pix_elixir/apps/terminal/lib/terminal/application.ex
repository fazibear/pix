defmodule Terminal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised

    children = if Mix.env == :dev do
      [worker(Terminal, [nil])]
    else
      [
        # Starts a worker by calling: Matrix.Worker.start_link(arg)
        # {Matrix.Worker, arg},
      ]
    end
    |> IO.inspect

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Terminal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
