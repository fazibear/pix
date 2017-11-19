defmodule Random do
  @moduledoc """
  Generates random pixels
  """

  use GenServer

  alias Display.Draw

  # 0
  @timeout 10

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, Draw.empty(), name: __MODULE__)
  end

  def init(state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

    {:ok, state}
  end

  def handle_info(:tick, state) do
    state = draw_random(state)

    Process.send_after(self(), :tick, @timeout)

    Display.data(__MODULE__, state)

    {:noreply, state}
  end

  defp draw_random(state) do
    Draw.dot(
      state,
      :rand.uniform(16) - 1,
      :rand.uniform(16) - 1,
      :rand.uniform(9) - 1
    )
  end
end
