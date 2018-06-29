defmodule Matrix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    children = matrix()

    # Starts a worker by calling: Matrix.Worker.start_link(arg)
    # {Matrix.Worker, arg},

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Matrix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :prod do
    def matrix do
      import Supervisor.Spec
      [worker(Matrix, [nil])]
    end
  else
    def matrix do
      []
    end
  end
end
