defmodule BitBay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    BitBay.start_link(name: BitBay)
  end
end
