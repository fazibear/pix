defmodule Pix.Output.MatrixMod do
  use GenStage

  @pix_file '/sys/pix/dot'


  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    state
    |> Map.put(:file, File.open(@pix_file, [:write]))

    {:consumer, state, subscribe_to: [Pix.Display]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      handle_event(event, state)
    end

    {:noreply, [], state}
  end

  def handle_event(event, state) do
    event
    |> Enum.with_index
    |> Enum.each(&handle_line(&1, state))
  end

  def handle_line({line, y}, state) do
    line
    |> Enum.with_index
    |> Enum.each(&handle_column(&1, y, state))
  end

  def handle_column({color, x}, y, state) do
    IO.write(state.file, "#{x} #{y} #{color(color)}")
  end

  def color(color) do
    case color do
      1 -> "1 0 0"
      2 -> "0 1 0"
      3 -> "1 1 0"
      4 -> "0 0 1"
      5 -> "1 0 1"
      6 -> "0 1 1"
      7 -> "1 1 1"
      _ -> "0 0 0"
    end
  end
end
