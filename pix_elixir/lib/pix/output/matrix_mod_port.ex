defmodule Pix.Output.MatrixModPort do
  use GenStage

  @pix_file '/sys/pix/dot'


  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    port = Port.open({:spawn, 'priv/sysfs'}, [:binary, {:packet, 2}])

    state = state
    |> Map.put(:port, port)

    {:consumer, state, subscribe_to: [Pix.Display]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      handle_event(event, state)
    end

    {:noreply, [], state}
  end

  def handle_event(event, state) do
    data = event
           |> List.flatten
           |> :erlang.list_to_binary
    Port.command(state.port, data)
  end
end
