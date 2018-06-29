defmodule Wotd do
  @moduledoc """
  Word of the day
  """

  use GenServer

  alias Display.Draw

  @timeout 100
  @fetch_timeout 1000 * 60 * 60
  @head_color 3
  @text_color 2

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)
    send(self(), :fetch)

    Display.time(__MODULE__, 15000)

    state = %{
      # lower case only !
      text: "fetching data ... ",
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
      |> draw_head()
      |> draw_text(state.text, state.position, state.letter)


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
    state = Map.put(state, :text, data)
    {:noreply, state}
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

  defp draw_head(state) do
    state
    |> Draw.char("w", 0, 0, @head_color)
    |> Draw.char("o", 4, 0, @head_color)
    |> Draw.char("t", 8, 0, @head_color)
    |> Draw.char("d", 12, 0, @head_color)
  end

  defp draw_text(state, text, position, letter) do
    state
    |> Draw.char(get_letter(text, letter, 0), 0 - position, 9, @text_color)
    |> Draw.char(get_letter(text, letter, 1), 4 - position, 9, @text_color)
    |> Draw.char(get_letter(text, letter, 2), 8 - position, 9, @text_color)
    |> Draw.char(get_letter(text, letter, 3), 12 - position, 9, @text_color)
    |> Draw.char(get_letter(text, letter, 4), 16 - position, 9, @text_color)
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

  defp fetch do
    pid = self()

    spawn(fn ->
      try do
        send(pid, {:fetched, fetch_word()})
      rescue
        _ -> :nothing
      end
    end)
  end

  def fetch_word do
    html = "https://www.diki.pl/slowko-dnia"
    |> HTTPotion.get!()
    |> Map.get(:body)

    word = html
           |> Floki.find("#contentWrapper > div.dikicolumn > div > div.dictionaryEntity > div.hws > span.hw > a")
           |> Floki.text
           |> String.downcase
           |> String.normalize(:nfd)
           |> String.replace(~r/[^A-z\s]/u, "")

    desc = html
          |> Floki.find("#meaning18718_id > span a")
          |> Floki.text(sep: " ")
          |> String.downcase
          |> String.normalize(:nfd)
          |> String.replace(~r/[^A-z\s]/u, "")

    "#{word}: #{desc}"
  end

end
