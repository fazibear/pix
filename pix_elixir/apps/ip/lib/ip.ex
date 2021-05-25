defmodule Ip do
  @moduledoc """
  Sample scolling text application application
  """

  use GenServer
  use Tesla

  alias Display.Draw

  @timeout 100
  @fetch_timeout 1000 * 60 * 60
  @offset 9
  @text_color 2
  @info_color 3

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
      letter: 0,
      position: 0
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
      |> Draw.char("m", 0, 0, @info_color)
      |> Draw.char("y", 4, 0, @info_color)
      |> Draw.char("i", 9, 0, @info_color)
      |> Draw.char("p", 13, 0, @info_color)
      |> draw_text(state.text, @text_color, state.position, state.letter)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    Process.send_after(self(), :fetch, @fetch_timeout)
    case get("https://icanhazip.com") do
      {:ok, response} ->
        {:noreply, Map.put(state, :text,  Map.get(response, :body))}
      _ ->
        {:noreply, state}
    end

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
      color
    )
    |> Draw.char(
      get_letter(text, letter, 1),
      4 - position,
      @offset,
      color
    )
    |> Draw.char(
      get_letter(text, letter, 2),
      8 - position,
      @offset,
      color
    )
    |> Draw.char(
      get_letter(text, letter, 3),
      12 - position,
      @offset,
      color
    )
    |> Draw.char(
      get_letter(text, letter, 4),
      16 - position,
      @offset,
      color
    )
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
