defmodule Firmware do
  def setup_time() do
    case Nerves.NetworkInterface.settings("wlan0") do
      {:ok, _} ->
        System.cmd("ntpd", ["-q", "-p", "pool.ntp.org"])

      _ ->
        :timer.sleep(500)
        setup_time()
    end
  end
end
