defmodule YearProgress do
  @moduledoc """
  Binary clock application
  """

  use GenServer

  alias Display.Draw

  @timeout 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)

    {:ok, year_progress()}
  end

  def terminate(_reason, state) do
    Display.remove(__MODULE__)

    {:ok, state}
  end

  def handle_info(:tick, _state) do
    state = year_progress()

    data =
      draw_template()
      |> draw_percent(state)
      |> draw_bar(state)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  defp draw_template() do
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7],
      [7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7],
      [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end

  defp draw_percent(data, percent) do
    string = percent
    |> Integer.to_string()
    |> String.pad_leading(3)

    data
    |> Draw.char("y", 1, 2, 4)
    |> Draw.char(String.at(string, 1), 5, 2, 3)
    |> Draw.char(String.at(string, 2), 9, 2, 3)
    |> Draw.char("%", 13, 2, 3)
  end

  defp draw_bar(data, percent) do
    Enum.reduce(0..round(percent/100 * 13), data, fn dot, data ->
      data
      |> Draw.dot(dot+1, 12, 2)
      |> Draw.dot(dot+1, 13, 2)
    end)
  end

  def year_progress do
    Date.utc_today()
    |> Date.day_of_year
    |> Kernel./(365)
    |> Kernel.*(100)
    |> round()
  end
end
