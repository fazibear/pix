defmodule Pix.Display do
  use GenStage

  def start_link(subscribers) do
    GenStage.start_link(__MODULE__, {subscribers, %{}}, name: __MODULE__)
  end

  def init({subscribers, state}) do
    {:producer_consumer, state, subscribe_to: subscribers}
  end

  def handle_events(events, _from, state) do
    state = events
    |> Enum.reduce(state, &put_into_state/2)

    {:noreply, [state.random], state}
  end

  defp put_into_state({key, value}, state) do
    state
    |> Map.put(key, value)
  end
end
