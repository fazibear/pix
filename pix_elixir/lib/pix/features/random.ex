defmodule Pix.Features.Random do
  use GenStage

  alias Pix.Draw

  @timeout 10 #0

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, Draw.empty, name: __MODULE__)
  end

  def init(state) do
    send self(), :tick

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = state
            |> draw_random

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:random, state}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp draw_random(state) do
    state
    |> Draw.dot(:rand.uniform(16)-1,:rand.uniform(16)-1,:rand.uniform(9)-1)
  end
end
