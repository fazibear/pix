defmodule GameOfLife do
  @moduledoc """
  Walking crab from space invaders
  """

  use GenServer

  alias Display.Draw

  @timeout 150

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)

    state = %{
      alive_cells: [{0, 0, 1}, {1, 0, 1}, {2, 0, 1}, {1, 1, 1}],
      color: 1
    }

    {:ok, state}
  end

  def terminate(_reason, state) do
    Display.remove(__MODULE__)

    {:ok, state}
  end

  def handle_info(:tick, state) do
    state =
      state
      |> cycle_color()
      |> add_random()
      |> game_tick()
      |> draw_data()

    Process.send_after(self(), :tick, @timeout)

    {:noreply, state}
  end

  defp draw_data(state) do
    data =
      state.alive_cells
      |> Enum.reduce(Draw.empty(), fn {x, y, c}, acc ->
        if c == 0 || c > 7, do: raise(:dupa)
        acc |> Draw.dot(x, y, c)
      end)

    Display.update(__MODULE__, data)
    state
  end

  defp cycle_color(state) do
    color = state.color + 1
    color = if color > 7, do: 1, else: color
    %{state | color: color}
  end

  defp add_random(%{alive_cells: cells} = state) when length(cells) == 0 do
    %{
      state
      | alive_cells:
          state.alive_cells ++
            Enum.reduce(0..15, [], fn _, acc ->
              acc ++ [{:rand.uniform(15), :rand.uniform(15), state.color}]
            end)
    }
  end

  defp add_random(state) do
    %{
      state
      | alive_cells: state.alive_cells ++ [{:rand.uniform(15), :rand.uniform(15), state.color}]
    }
  end

  defp game_tick(state) do
    %{
      state
      | alive_cells:
          keep_alive_tick(state.alive_cells) ++
            become_alive_tick(state.alive_cells, state.color)
    }
  end

  defp keep_alive?(alive_cells, {x, y, _} = _alive_cell) do
    case count_neighbours(alive_cells, x, y, 0) do
      2 -> true
      3 -> true
      _ -> false
    end
  end

  defp become_alive?(alive_cells, {x, y, _} = _dead_cell) do
    3 == count_neighbours(alive_cells, x, y, 0)
  end

  defp count_neighbours([head_cell | tail_cells], x, y, count) do
    increment =
      case head_cell do
        {hx, hy, _} when hx == x - 1 and hy == y - 1 -> 1
        {hx, hy, _} when hx == x and hy == y - 1 -> 1
        {hx, hy, _} when hx == x + 1 and hy == y - 1 -> 1
        {hx, hy, _} when hx == x - 1 and hy == y -> 1
        {hx, hy, _} when hx == x + 1 and hy == y -> 1
        {hx, hy, _} when hx == x - 1 and hy == y + 1 -> 1
        {hx, hy, _} when hx == x and hy == y + 1 -> 1
        {hx, hy, _} when hx == x + 1 and hy == y + 1 -> 1
        _not_neighbour -> 0
      end

    count_neighbours(tail_cells, x, y, count + increment)
  end

  defp count_neighbours([], _x, _y, count), do: count

  defp dead_neighbours(alive_cells) do
    neighbours = neighbours(alive_cells, [])
    (neighbours |> Enum.uniq()) -- alive_cells
  end

  defp neighbours([{x, y, c} | cells], neighbours) do
    neighbours(
      cells,
      neighbours ++
        [
          {x - 1, y - 1, c},
          {x, y - 1, c},
          {x + 1, y - 1, c},
          {x - 1, y, c},
          {x + 1, y, c},
          {x - 1, y + 1, c},
          {x, y + 1, c},
          {x + 1, y + 1, c}
        ]
    )
  end

  defp neighbours([], neighbours), do: neighbours

  defp keep_alive_or_nilify(alive_cells, cell) do
    if keep_alive?(alive_cells, cell), do: cell, else: nil
  end

  defp remove_nil_cells(cells) do
    cells
    |> Enum.filter(fn cell -> cell != nil end)
    |> Enum.filter(fn {x, y, _} -> x > -1 && x < 16 && y > -1 && y < 16 end)
  end

  defp become_alive_or_nilify(alive_cells, {x, y, _} = dead_cell, color) do
    if become_alive?(alive_cells, dead_cell), do: {x, y, color}, else: nil
  end

  defp keep_alive_tick(alive_cells) do
    alive_cells
    |> Enum.map(&keep_alive_or_nilify(alive_cells, &1))
    |> remove_nil_cells
  end

  defp become_alive_tick(alive_cells, color) do
    alive_cells
    |> dead_neighbours()
    |> Enum.map(&become_alive_or_nilify(alive_cells, &1, color))
    |> remove_nil_cells
  end
end
