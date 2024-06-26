defmodule Weather do
  @moduledoc """
  Shows weather
  """

  use GenServer
  use Tesla

  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 200
  @fetch_timeout 1000 * 60
  @temp_color 2

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :fetch)
    send(self(), :tick)

    state = %{
      cloud_pos: 0,
      tick: 0,
      temp: "   ",
      symbol: "01d"
    }

    {:ok, state}
  end

  def terminate(_reason, state) do
    Display.remove(__MODULE__)

    {:ok, state}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data =
      Draw.empty()
      |> draw_sun(state.symbol, state.tick)
      |> draw_moon(state.symbol, state.tick)
      |> draw_cloud(state.symbol, state.cloud_pos)
      |> draw_rain(state.symbol, state.cloud_pos, state.tick)
      |> draw_snow(state.symbol, state.cloud_pos, state.tick)
      |> draw_thunder(state.symbol, state.cloud_pos, state.tick)
      |> draw_temp(state.temp)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    Process.send_after(self(), :fetch, @fetch_timeout)
    fetch()
    {:noreply, state}
  end

  def handle_info({:fetched, data}, state) do
    {:noreply, Map.merge(state, data)}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  defp draw_temp(data, temp) do
    data
    |> Draw.char(String.at(temp, 0), 5, 9, @temp_color)
    |> Draw.char(String.at(temp, 1), 9, 9, @temp_color)
    |> Draw.char(String.at(temp, 2), 13, 9, @temp_color)
  end

  defp draw_sun(data, symbol, tick) do
    if Enum.member?(["01d", "02d", "10d"], symbol) do
      Draw.symbol(data, {Symbol, "sun_#{tick}"}, 8, 0)
    else
      data
    end
  end

  defp draw_moon(data, symbol, tick) do
    if Enum.member?(["01n", "02n", "10n"], symbol) do
      data
      |> Draw.symbol({Symbol, :moon}, 11, 0)
      |> Draw.symbol({Symbol, "dot_#{tick}"}, 2, 4)
      |> Draw.symbol({Symbol, "dot_#{tick}"}, 7, 1)
    else
      data
    end
  end

  defp draw_cloud(data, symbol, pos) do
    if Enum.member?(["01d", "01n"], symbol) do
      data
    else
      Draw.symbol(data, {Symbol, :cloud}, pos, 1)
    end
  end

  defp draw_rain(data, symbol, pos, tick) do
    if Enum.member?(["09d", "10d", "09n", "10n"], symbol) do
      Draw.symbol(data, {Symbol, "rain_#{tick}"}, pos + 3, 8)
    else
      data
    end
  end

  defp draw_snow(data, symbol, pos, tick) do
    if Enum.member?(["13d", "13n"], symbol) do
      Draw.symbol(data, {Symbol, "snow_#{tick}"}, pos, 9)
    else
      data
    end
  end

  defp draw_thunder(data, symbol, pos, tick) do
    if Enum.member?(["11d", "11n"], symbol) and tick == 0 do
      Draw.symbol(data, {Symbol, :thunder}, pos + 2, 8)
    else
      data
    end
  end

  defp fetch do
    pid = self()

    spawn(fn ->
      #try do
        send(pid, {:fetched, Weather.Fetcher.fetch()})
      # rescue
      #   _ -> :nothing
      # end
    end)
  end

  defp tick(state) do
    %{
      state
      | cloud_pos: move_cloud(state.cloud_pos),
        tick: if(state.tick == 0, do: 1, else: 0)
    }
  end

  def move_cloud(pos) when pos < -9, do: 15
  def move_cloud(pos), do: pos - 1

end
