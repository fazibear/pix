defmodule BinaryClock do
  @moduledoc """
  Binary clock application
  """

  use GenServer

  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 1000
  @on_color 6
  @off_color 4
  @dot_color 3

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)

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
      |> draw_time(state.time)
      |> draw_dots(state.dot)

    Process.send_after(self(), :tick, @timeout)

    Display.data(__MODULE__, data)

    {:noreply, state}
  end

  defp draw_time(data, time) do
    [
      [h11, h12, h13, h14],
      [h21, h22, h23, h24],
      [m11, m12, m13, m14],
      [m21, m22, m23, m24]
    ] = time

    data
    |> Draw.symbol({Symbol, "dot_2"}, 1, 1, color(h11))
    |> Draw.symbol({Symbol, "dot_2"}, 1, 5, color(h12))
    |> Draw.symbol({Symbol, "dot_2"}, 1, 9, color(h13))
    |> Draw.symbol({Symbol, "dot_2"}, 1, 13, color(h14))
    |> Draw.symbol({Symbol, "dot_2"}, 4, 1, color(h21))
    |> Draw.symbol({Symbol, "dot_2"}, 4, 5, color(h22))
    |> Draw.symbol({Symbol, "dot_2"}, 4, 9, color(h23))
    |> Draw.symbol({Symbol, "dot_2"}, 4, 13, color(h24))
    |> Draw.symbol({Symbol, "dot_2"}, 10, 1, color(m11))
    |> Draw.symbol({Symbol, "dot_2"}, 10, 5, color(m12))
    |> Draw.symbol({Symbol, "dot_2"}, 10, 9, color(m13))
    |> Draw.symbol({Symbol, "dot_2"}, 10, 13, color(m14))
    |> Draw.symbol({Symbol, "dot_2"}, 13, 1, color(m21))
    |> Draw.symbol({Symbol, "dot_2"}, 13, 5, color(m22))
    |> Draw.symbol({Symbol, "dot_2"}, 13, 9, color(m23))
    |> Draw.symbol({Symbol, "dot_2"}, 13, 13, color(m24))
  end

  defp draw_dots(data, dot) do
    data
    |> Draw.symbol({Symbol, dot}, 7, 4, @dot_color)
    |> Draw.symbol({Symbol, dot}, 7, 10, @dot_color)
  end

  defp color(value) do
    case value do
      "1" -> @on_color
      _ -> @off_color
    end
  end

  defp tick(state) do
    %{
      dot: if(Map.get(state, :dot) == "dot_3", do: "dot_4", else: "dot_3"),
      time: current_time()
    }
  end

  defp current_time do
    "Europe/Warsaw"
    |> Timex.now()
    |> Timex.format!("%H%M", :strftime)
    |> String.split("", trim: true)
    |> Enum.map(&to_bin/1)
  end

  defp to_bin(int) do
    int
    |> Convertat.from_base(10)
    |> Convertat.to_base(2)
    |> String.pad_leading(4, "0")
    |> String.split("", trim: true)
  end
end
