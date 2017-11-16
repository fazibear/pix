defmodule Matrix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    children =
      if Mix.env() == :prod do
        import Supervisor.Spec
        [worker(Matrix, [nil])]
      else
        [
          # Starts a worker by calling: Matrix.Worker.start_link(arg)
          # {Matrix.Worker, arg},
        ]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Matrix.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
