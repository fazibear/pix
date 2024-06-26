defmodule DisplayTerm do
  @moduledoc """
  Takes data from display and draw them on display_term
  """

  use GenServer
  alias IO.ANSI

  def data(data) do
    GenServer.cast(__MODULE__, {:data, data})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:data, data}, state) do
    draw(data)

    {:noreply, state}
  end

  defp draw(state) do
    state
    |> Enum.map(&process_line/1)
    |> List.insert_at(0, [IO.ANSI.clear(), IO.ANSI.home()])
    |> ANSI.format()
    |> IO.puts()
  end

  defp process_line(line) do
    line
    |> Enum.map(&process_pix/1)
    |> Kernel.++("\n")
  end

  defp process_pix(pix) do
    [
      color(pix),
      # "██"
      #  "■ "
       "▀ "
    ]
  end

  defp color(color) do
    case color do
      1 -> :red
      2 -> :green
      3 -> :yellow
      4 -> :blue
      5 -> :magenta
      6 -> :cyan
      7 -> :white
      _ -> :black
    end
  end
end
