defmodule Lastfm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Lastfm
    ]

    opts = [
      strategy: :one_for_one,
      name: Lastfm.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
