defmodule Matrix do
  use GenStage

  @port_path :matrix |> Application.app_dir("priv/matrix") |> String.to_charlist

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    port = Port.open({:spawn, @port_path}, [{:packet, 2}])

    state = state
    |> Map.put(:port, port)

    {:consumer, state, subscribe_to: [Display]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      handle_event(event, state.port)
    end

    {:noreply, [], state}
  end

  def handle_event(event, port) do
    data = event
           |> List.flatten
           |> :erlang.list_to_binary

    Port.command(port, data)
  end
end
