defmodule BitBay do
  @moduledoc """
  Sample scolling text application application
  """

  use GenServer
  use Tesla

  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 100
  @fetch_timeout 1000 * 60 * 5
  @offset 9

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)
    send(self(), :fetch)

    Display.time(__MODULE__, 15000)

    state = %{
      # lower case only !
      text: "waiting for data... ",
      color: "12345671234567123456",
      letter: 0,
      position: 0,
      data: %{}
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
      |> Draw.symbol({Symbol, "coin"}, 0, 1, 3)
      |> Draw.symbol({Symbol, "coin"}, 4, 4, 4)
      |> Draw.symbol({Symbol, "coin"}, 8, 1, 2)
      |> Draw.symbol({Symbol, "coin"}, 12, 4, 5)
      |> draw_text(state.text, state.color, state.position, state.letter)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    Process.send_after(self(), :fetch, @fetch_timeout)
    fetch("BTCPLN")
    fetch("ETHPLN")

    {:noreply, state}
  end

  def handle_info({:fetched, type, data}, state) do
    state = state
    |> put_data(type, data)
    |> put_wallet()
    |> clear_text()
    |> put_text("5", "sum:", "WALLET")
    |> put_text("3", "btc:", "BTCPLN")
    |> put_text("4", "eth:", "ETHPLN")

    {:noreply, state}
  end

  defp fetch(type) do
    pid = self()

    spawn(fn ->
      try do
        data =
          type
          |> fetch_ticker()
          |> extract_data()

        send(pid, {:fetched, type, data})
      rescue
        _ -> :nothing
      end
    end)
  end

  def extract_data(%{"average" => average}), do: average
  def extract_data(_), do: raise(ArgumentError)

  def fetch_ticker(type) do
    "https://bitbay.net/API/Public/#{type}/ticker.json"
    |> get!()
    |> Map.get(:body)
    |> Jason.decode!()
  end

  def put_data(state, type, data) do
    put_in(state[:data][type], data)
  end

  def put_wallet(state) do
    sum = :bit_bay
          |> Application.fetch_env!(:wallet)
          |> Enum.map(fn ({type, value}) -> {type, Map.get(state.data, String.upcase("#{type}PLN"), 0) * value} end)
          |> Keyword.values()
          |> Enum.sum()
          |> Float.round(2)

    put_data(state, "WALLET", sum)
  end

  def clear_text(state) do
    state
    |> Map.put(:text, "")
    |> Map.put(:color, "")
  end

  def put_text(state, color, header, data) do
    text = "#{header}#{Map.get(state.data, data, "*")} "

    state
    |> Map.put(:text, "#{state.text}#{text}")
    |> Map.put(:color, "#{state.color}#{String.pad_leading("", String.length(text), color)}")
  end

  defp tick(state) do
    state =
      if state.position > 2 do
        state
        |> Map.put(:position, 0)
        |> Map.put(:letter, state.letter + 1)
      else
        Map.put(state, :position, state.position + 1)
      end

    if state.letter >= String.length(state.text) do
      Map.put(state, :letter, 0)
    else
      state
    end
  end

  defp draw_text(state, text, color, position, letter) do
    state
    |> Draw.char(
      get_letter(text, letter, 0),
      0 - position,
      @offset,
      get_color(color, letter, 0)
    )
    |> Draw.char(
      get_letter(text, letter, 1),
      4 - position,
      @offset,
      get_color(color, letter, 1)
    )
    |> Draw.char(
      get_letter(text, letter, 2),
      8 - position,
      @offset,
      get_color(color, letter, 2)
    )
    |> Draw.char(
      get_letter(text, letter, 3),
      12 - position,
      @offset,
      get_color(color, letter, 3)
    )
    |> Draw.char(
      get_letter(text, letter, 4),
      16 - position,
      @offset,
      get_color(color, letter, 4)
    )
  end

  defp get_color(text, letter, pos) do
    text
    |> get_letter(letter, pos)
    |> String.to_integer()
  end

  defp get_letter(text, letter, pos) do
    len = String.length(text)

    letter =
      if letter + pos >= len do
        letter + pos - len
      else
        letter + pos
      end

    String.at(text, letter)
  end
end
