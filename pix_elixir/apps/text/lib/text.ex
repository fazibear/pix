defmodule Text do
  @moduledoc """
  Sample scolling text application application
  """

  use GenServer

  alias String.Chars
  alias Display.Draw

  @timeout 100
  @color 7

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

    state = %{
      text: "to jest fany text na mej ramce",
      position: 0,
    }

    {:ok, state}
  end

  def terminate(_reason, state) do
    Display.unsubscribe(__MODULE__)

    {:ok, state}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data =
      Draw.empty()
      |> draw_text(state.text, state.position)

    Process.send_after(self(), :tick, @timeout)

    Display.data(__MODULE__, data)

    {:noreply, state}
  end

  defp tick(state) do
    if state.position + 4 > String.length(state.text) do
      Map.put(state, :position, 0)
    else
      Map.put(state, :position, state.position + 1)
    end
  end

  defp draw_text(state, text, position) do
    state
    |> Draw.char(String.at(text, position), 0, 0, @color)
    |> Draw.char(String.at(text, position + 1), 4, 0, @color)
    |> Draw.char(String.at(text, position + 2), 9, 0, @color)
    |> Draw.char(String.at(text, position + 3), 13, 0, @color)
  end
end
