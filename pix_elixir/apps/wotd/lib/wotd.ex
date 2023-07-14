defmodule Wotd do
  @moduledoc """
  Word of the day
  """

  use GenServer
  use Tesla

  alias Display.Draw

  @timeout 100
  @fetch_timeout 1000 * 60 * 60

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    send(self(), :tick)
    send(self(), :fetch)

    Display.time(__MODULE__, 15000)

    state = %{
      up: %{
        text: "fetching ",
        letter: 0,
        position: 0,
        color: 3,
        offset: 0
      },
      down: %{
        text: "data ",
        letter: 0,
        position: 0,
        color: 2,
        offset: 9
      }
    }

    {:ok, state}
  end

  def terminate(_reason, state) do
    Display.remove(__MODULE__)

    {:ok, state}
  end

  def handle_info(:tick, state) do
    state = put_in(state.up, tick(state.up))
    state = put_in(state.down, tick(state.down))

    data =
      Draw.empty()
      |> draw_text(state.up)
      |> draw_text(state.down)

    Process.send_after(self(), :tick, @timeout)

    Display.update(__MODULE__, data)

    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    Process.send_after(self(), :fetch, @fetch_timeout)
    fetch()
    {:noreply, state}
  end

  def handle_info({:fetched, {up, down}}, state) do
    state = put_in(state.up.text, up)
    state = put_in(state.down.text, down)

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

  defp draw_text(state, %{
         text: text,
         position: position,
         letter: letter,
         offset: offset,
         color: color
       }) do
    state
    |> Draw.char(get_letter(text, letter, 0), 0 - position, offset, color)
    |> Draw.char(get_letter(text, letter, 1), 4 - position, offset, color)
    |> Draw.char(get_letter(text, letter, 2), 8 - position, offset, color)
    |> Draw.char(get_letter(text, letter, 3), 12 - position, offset, color)
    |> Draw.char(get_letter(text, letter, 4), 16 - position, offset, color)
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
    html =
      "https://www.diki.pl/dictionary/word-of-the-day"
      |> get!()
      |> Map.get(:body)

    word =
      html
      |> extract(
        "#contentWrapper > div.dikicolumn > div > div.dictionaryEntity > div.hws > span.hw > a"
      )

    desc =
      html
      |> extract(".foreignToNativeMeanings a.plainLink")

    {"#{word} ", "#{desc} "}
  end

  def extract(html, selector) do
    html
    |> Floki.parse_document()
    |> Floki.find(selector)
    |> Floki.text(sep: " ")
    |> strip()
  end

  def strip(string) do
    string
    |> String.downcase()
    |> String.replace("ł", "l")
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z,\.\-\s]/u, "")
  end
end
