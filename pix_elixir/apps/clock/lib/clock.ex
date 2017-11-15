defmodule Clock do
  @moduledoc """
  Simple clock application
  """

  use GenStage

  alias String.Chars
  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 1000
  @dot_color 3
  @digits_color 7

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data =
      Draw.empty()
      |> draw_time(state.time)
      |> draw_dots(state.dot)

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, data}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp tick(state) do
    %{
      dot: if(Map.get(state, :dot) == "dot_0", do: "dot_1", else: "dot_0"),
      time: current_time()
    }
  end

  defp draw_time(state, time) do
    state
    |> Draw.char(String.at(time, 0), 0, 0, @digits_color)
    |> Draw.char(String.at(time, 1), 4, 0, @digits_color)
    |> Draw.char(String.at(time, 2), 9, 9, @digits_color)
    |> Draw.char(String.at(time, 3), 13, 9, @digits_color)
  end

  defp draw_dots(state, dot) do
    state
    |> Draw.symbol({Symbol, dot}, 11, 2, @dot_color)
    |> Draw.symbol({Symbol, dot}, 2, 11, @dot_color)
  end

  defp current_time do
    {{_, _, _}, {h, m, _}} = :calendar.local_time()

    "~2.10. B~2.10.0B"
    |> :io_lib.format([h, m])
    |> Chars.to_string()
  end
end
