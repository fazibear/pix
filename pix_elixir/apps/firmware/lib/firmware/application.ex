defmodule Firmware.Application do
  @moduledoc """
  Firmware
  """
  use Application

  def start(_type, _args) do
    Firmware.init()
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(network(), opts)
  end

  def network() do
    import Supervisor.Spec, warn: false
    [
      worker(SystemRegistry.Task, [
        [:state, :network_interface, "wlan0", :ipv4_address],
        &Firmware.network/1
      ])
    ]
  end
end
