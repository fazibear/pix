defmodule BitBay do
  @moduledoc """
  Sample scolling text application application
  """

  use GenServer

  alias Display.Draw

  @timeout 100
  @fetch_timeout 1000 * 60 * 5
  @offset 5

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)
    send(self(), :fetch)

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
      |> draw_text(state.text, state.color, state.position, state.letter)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    Process.send_after(self(), :fetch, @fetch_timeout)
    fetch("BTCPLN")
    fetch("ETHPLN")
    fetch("LTCPLN")
    fetch("XRPPLN")
    {:noreply, state}
  end

  def handle_info({:fetched, type, data}, state) do
    state = put_in(state[:data][type], data)
    state = put_in(state.text, format_text(state.data))
    state = put_in(state.color, format_color(state.data))
    {:noreply, state}
  end

  defp fetch(type) do
    pid = self()

    spawn(fn ->
      try do
        send(pid, {:fetched, type, fetch_ticker(type)})
      rescue
        _ -> :nothing
      end
    end)
  end

  def fetch_ticker(type) do
    "https://bitbay.net/API/Public/#{type}/ticker.json"
    |> HTTPotion.get!()
    |> Map.get(:body)
    |> Poison.decode!()
  end

  def format_text(data) do
    text(data, "btc:", "BTCPLN") <>
      text(data, "eth:", "ETHPLN") <>
      text(data, "ltc:", "LTCPLN") <> text(data, "xrp:", "XRPPLN")
  end

  def text(data, header, type, value \\ "average") do
    "#{header}#{data[type][value]} "
  end

  def format_color(data) do
    color(data, "3", "btc:", "BTCPLN") <>
      color(data, "4", "eth:", "ETHPLN") <>
      color(data, "2", "ltc:", "LTCPLN") <> color(data, "5", "xrp:", "XRPPLN")
  end

  def color(data, color, header, type, value \\ "average") do
    String.pad_leading(
      "",
      String.length(text(data, header, type, value)),
      color
    )
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
