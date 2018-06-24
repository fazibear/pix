defmodule Firmware do
  @moduledoc """
  Firmware
  """

  def init() do
    start_ssh()
    start_ntp()
  end

  def start_ntp() do
    System.cmd("ntpd", ["-p", "pool.ntp.org"])
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
