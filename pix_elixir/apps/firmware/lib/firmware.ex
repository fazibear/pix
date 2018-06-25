defmodule Firmware do
  @moduledoc """
  Firmware
  """

  require Logger

  def init() do
    start_ssh()
  end

  def network({_ip, nil}) do
    set_time()
  end

  def network(_), do: :nothing

  def set_time() do
    System.put_env("TZ", "Poland-2")
    System.cmd("ntpd", ~w[-n -q -p pool.ntp.org], into: Nerves.Runtime.OutputLogger.new(:info))
  end

  def start_ssh() do
    authorized_keys =
      Application.get_env(:nerves_firmware_ssh, :authorized_keys, [])
      |> Enum.join("\n")

    decoded_authorized_keys = :public_key.ssh_decode(authorized_keys, :auth_keys)

    cb_opts = [authorized_keys: decoded_authorized_keys]
    system_dir = :code.priv_dir(:nerves_firmware_ssh)

    {:ok, _ref} =
      :ssh.daemon(22, [
        {:key_cb, {Nerves.Firmware.SSH.Keys, cb_opts}},
        {:system_dir, system_dir},
        shell: {IEx, :start, []}
      ])
  end
end
