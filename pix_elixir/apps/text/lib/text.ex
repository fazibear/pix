defmodule Text do
  @moduledoc """
  Sample scolling text application application
  """

  use GenServer

  alias Display.Draw

  @timeout 50
  @color 7

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

    state = %{
      # lower case only !
      text: "to jest fany text na mej ramce",
      letter: 0,
      position: 0
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
      |> draw_text(state.text, state.position, state.letter)

    Process.send_after(self(), :tick, @timeout)

    Display.data(__MODULE__, data)

    {:noreply, state}
  end

  defp tick(state) do
    state = if state.position > 2 do
      state
      |> Map.put(:position, 0)
      |> Map.put(:letter, state.letter + 1)
    else
      Map.put(state, :position, state.position + 1)
    end

    if state.letter + 5 > String.length(state.text) do
      Map.put(state, :letter, 0)
    else
      state
    end
  end

  defp draw_text(state, text, position, letter) do
    state
    |> Draw.char(String.at(text, letter),     0 - position, 9, @color)
    |> Draw.char(String.at(text, letter + 1), 4 - position, 9, @color)
    |> Draw.char(String.at(text, letter + 2), 8 - position, 9, @color)
    |> Draw.char(String.at(text, letter + 3), 12 - position, 9, @color)
    |> Draw.char(String.at(text, letter + 4), 16 - position, 9, @color)
  end
end
