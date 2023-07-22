defmodule DisplayPort.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DisplayPort
    ]
    opts = [
      strategy: :one_for_one,
      name: DisplayPort.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end
end
