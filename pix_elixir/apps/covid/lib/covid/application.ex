defmodule Covid.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Covid
    ]

    opts = [
      strategy: :one_for_one,
      name: Covid.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
