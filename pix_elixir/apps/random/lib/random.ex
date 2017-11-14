defmodule Random do
  @moduledoc """
  Generates random pixels
  """

  use GenStage

  alias Display.Draw

  @timeout 10 #0

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, Draw.empty, name: __MODULE__)
  end

  def init(state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = draw_random(state)

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, state}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp draw_random(state) do
    Draw.dot(
      state,
      :rand.uniform(16) - 1,
      :rand.uniform(16) - 1,
      :rand.uniform(9) - 1
    )
  end
end
