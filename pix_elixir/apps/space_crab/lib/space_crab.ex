defmodule SpaceCrab do
  use GenStage

  alias Display.Draw

  @timeout 150
  @crab_color 3

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    Display.subscribe(__MODULE__)

    Process.send_after(self(), :tick, 100)
    state = %{
      crab: "crab_0",
      x: :rand.uniform(5) - 1,
      y: :rand.uniform(9) - 1,
      dir_x: true,
      dir_y: true,
      color: :rand.uniform(7)
    }

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data = Draw.empty
           |> Draw.char(state.crab, state.x, state.y, state.color)

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, data}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp tick(state) do
    state
    |> change_color()
    |> animate()
    |> move_x()
    |> check_x()
    |> move_y()
    |> check_y()
  end

  def change_color(state) do
    if :rand.uniform(10) == 1 do
      %{state | color: :rand.uniform(7)}
    else
      state
    end
  end

  def animate(state) do
    if state.crab == "crab_0" do
     %{state | crab: "crab_1"}
    else
     %{state | crab: "crab_0"}
    end
  end

  def move_x(state) do
    if state.dir_x do
      %{state | x: state.x + 1}
    else
      %{state | x: state.x - 1}
    end
  end

  def check_x(%{x: x} = state) when x < 0 do
    state
    |> Map.put(:dir_x, !state.dir_x)
    |> Map.put(:x, 1)
  end

  def check_x(%{x: x} = state) when x > 5 do
    state
    |> Map.put(:dir_x, !state.dir_x)
    |> Map.put(:x, 4)
  end

  def check_x(state), do: state

  def move_y(state) do
    if state.dir_y do
      %{state | y: state.y + 1}
    else
      %{state | y: state.y - 1}
    end
  end

  def check_y(%{y: y} = state) when y < 0 do
    state
    |> Map.put(:dir_y, !state.dir_y)
    |> Map.put(:y, 1)
  end

  def check_y(%{y: y} = state) when y > 8 do
    state
    |> Map.put(:dir_y, !state.dir_y)
    |> Map.put(:y, 7)
  end

  def check_y(state), do: state

end