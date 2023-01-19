defmodule Ip.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ip
    ]

    opts = [
      strategy: :one_for_one,
      name: Ip.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
