defmodule Terminal do
  @moduledoc """
  Takes data from display and draw them on terminal
  """

  use GenServer
  alias IO.ANSI

  def display(data) do
    GenStage.cast(__MODULE__, {:display, data})
  end

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_cast({:display, data}, state) do
    Enum.each(data, &draw/1)

    {:noreply, state}
  end

  defp draw(state) do
    state
    |> Enum.map(&process_line/1)
    |> ANSI.format()
    |> List.insert_at(0, [IO.ANSI.clear(), IO.ANSI.home()])
    |> IO.puts()
  end

  defp process_line(line) do
    line
    |> Enum.map(&process_pix/1)
    |> Kernel.++("\n")
  end

  defp process_pix(pix) do
    [color(pix), "■ "]
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
