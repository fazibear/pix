defmodule Weather do
  @moduledoc """
  Shows weather
  """

  use GenStage

  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 1000
  @fetch_timeout 1000 * 60 * 5
  @temp_color 2

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Display.subscribe(__MODULE__)

    send self(), :fetch
    Process.send_after(self(), :tick, 100)

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data = Draw.empty
            |> draw_temp(state.temp)
            |> draw_icon(state.symbol)

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, data}], state}
  end

  def handle_info(:fetch, state) do
    state = fetch(state)

    Process.send_after(self(), :fetch, @fetch_timeout)

    {:noreply, [], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp draw_temp(data, temp) do
    data
    |> Draw.char(String.at(temp, 0), 5, 9, @temp_color)
    |> Draw.char(String.at(temp, 1), 9, 9, @temp_color)
    |> Draw.char(String.at(temp, 2), 13, 9, @temp_color)
  end

  defp draw_icon(data, ["0", "1", "d"]) do
    data
    |> Draw.symbol({Symbol, :sun_0}, 8, 0)
  end

  defp draw_icon(data, ["0", "1", "n"]) do
    data
    |> Draw.symbol({Symbol, :moon}, 11, 0)
  end

  defp draw_icon(data, ["0", "2", "d"]) do
    data
    |> Draw.symbol({Symbol, :sun_0}, 8, 0)
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp draw_icon(data, ["0", "2", "n"]) do
    data
    |> Draw.symbol({Symbol, :moon}, 11, 0)
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp draw_icon(data, ["0", "3", _]) do
    data
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp draw_icon(data, ["0", "4", _]) do
    data
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp draw_icon(data, ["0", "9", _]) do
    data
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
    |> Draw.symbol({Symbol, :rain}, 3, 8)
  end

  defp draw_icon(data, ["1", "0", "d"]) do
    data
    |> Draw.symbol({Symbol, :sun_0}, 8, 0)
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
    |> Draw.symbol({Symbol, :rain}, 3, 8)
  end

  defp draw_icon(data, ["1", "0", "n"]) do
    data
    |> Draw.symbol({Symbol, :sun_0}, 8, 0)
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
    |> Draw.symbol({Symbol, :moon}, 3, 8)
  end

  defp draw_icon(data, ["1", "1", _]) do
    data
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp draw_icon(data, ["1", "3", _]) do
    data
    |> Draw.symbol({Symbol, :cloud}, 0, 1)
  end

  defp fetch(state) do
    Map.merge(state, fetch_weather())
  end

  defp tick(state) do
    state
  end

  def fetch_weather do
    json = "https://api.openweathermap.org/data/2.5/weather"
    |> HTTPotion.get(query: owm_query())
    |> Map.get(:body)
    |> Poison.decode!()

    %{
      temp: get_temp(json),
      symbol: get_symbol(json)
    }
  end

  def owm_query do
    %{
      q: "Warsaw,pl",
      units: "metric",
      appid: Application.fetch_env!(:weather, :owm_key)
    }
  end

  def get_temp(response) do
    response
    |> Map.get("main")
    |> Map.get("temp")
    |> Kernel.inspect
    |> String.pad_leading(3, " ")
  end

  def get_symbol(response) do
    response
    |> Map.get("weather")
    |> List.first
    |> Map.get("icon")
    |> String.split("", trim: true)
  end
end
