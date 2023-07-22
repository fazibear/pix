defmodule DisplaySysfs do
  @moduledoc """
  Takes data from display and send them to kernel module via display_sysfs
  """

  use GenServer

  @port_path :display_sysfs |> Application.app_dir("priv/display_sysfs") |> String.to_charlist()

  def data(data) do
    GenServer.cast(__MODULE__, {:data, data})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    port = Port.open({:spawn, @port_path}, [{:packet, 2}])

    state = Map.put(state, :port, port)

    {:consumer, state, subscribe_to: [Display]}
  end

  def handle_cast({:data, data}, state) do
    data =
      data
      |> List.flatten()
      |> :erlang.list_to_binary()

    Port.command(state.port, data)

    {:noreply, state}
  end
end
