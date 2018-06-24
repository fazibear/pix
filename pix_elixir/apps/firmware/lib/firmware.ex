defmodule Firmware do
  @moduledoc """
  Firmware
  """

  def init() do
    start_ntp()
  end

  def start_ntp() do
    System.cmd("ntpd", ["-p", "pool.ntp.org"])
  end
end
