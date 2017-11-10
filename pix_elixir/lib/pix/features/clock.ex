defmodule Pix.Features.Clock do
  use GenStage

  alias Pix.Draw

  @timeout 1000

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, Draw.empty, name: __MODULE__)
  end

  def init(state) do
    send self(), :tick

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    clock = Draw.empty
            |> draw_time(current_time())
            |> draw_dots(current_sec())

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, clock}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp draw_time(state, time) do
    state
    |> Draw.char(String.at(time, 0), 0, 0, 7)
    |> Draw.char(String.at(time, 1), 4, 0, 7)
    |> Draw.char(String.at(time, 2), 9, 9, 7)
    |> Draw.char(String.at(time, 3), 13, 9, 7)
  end

  defp draw_dots(state, s) do
    state
    |> Draw.char("dot#{rem(s, 2)}", 11, 2, 2)
    |> Draw.char("dot#{rem(s, 2)}", 2, 11, 2)
  end

  defp current_time do
    {{_,_,_}, {h, m, _}} = :calendar.local_time()

    :io_lib.format("~2.10. B~2.10.0B", [h,m])
    |> String.Chars.to_string()
  end

  defp current_sec do
    {{_,_,_}, {_, _, s}} = :calendar.local_time()
    s
  end
end
