defmodule SpaceCrab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      SpaceCrab
    ]

    opts = [
      strategy: :one_for_one,
      name: SpaceCrab.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
