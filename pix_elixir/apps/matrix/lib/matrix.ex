defmodule Matrix do
  @moduledoc """
  Takes data from display, and draw them on GPIO matrix using port
  """

  use GenServer

  def data(data) do
    GenServer.cast(__MODULE__, {:data, data})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    port = Port.open({:spawn, port_path()}, [{:packet, 2}])

    state = Map.put(state, :port, port)

    {:ok, state}
  end

  def handle_cast({:data, data}, state) do
    data =
      data
      |> List.flatten()
      |> :erlang.list_to_binary()

    Port.command(state.port, data)

    {:noreply, state}
  end

  def port_path do
    :matrix
    |> Application.app_dir("priv/matrix")
    |> String.to_charlist()
  end

end
