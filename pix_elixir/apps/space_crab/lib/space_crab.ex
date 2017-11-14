defmodule SpaceCrab do
  @moduledoc """
  Walking crab from space invaders
  """

  use GenStage

  alias Display.Draw
  alias Display.Draw.Symbol

  @timeout 150

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
      color: rand_color()
    }

    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_info(:tick, state) do
    state = tick(state)

    data = Draw.symbol(
      Draw.empty,
      {Symbol, state.crab},
      state.x,
      state.y,
      state.color
    )

    Process.send_after(self(), :tick, @timeout)

    {:noreply, [{:data, __MODULE__, data}], state}
  end

  def handle_demand(_demand, state), do: {:noreply, [], state}

  defp tick(state) do
    state
    |> animate()
    |> move_x()
    |> check_x()
    |> move_y()
    |> check_y()
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
    %{state |
      dir_x: !state.dir_x,
      x: 1,
      color: rand_color()
    }
  end

  def check_x(%{x: x} = state) when x > 5 do
    %{state |
      dir_x: !state.dir_x,
      x: 4,
      color: rand_color()
    }
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
    %{state |
      dir_y: !state.dir_y,
      y: 1,
      color: rand_color()
    }
  end

  def check_y(%{y: y} = state) when y > 8 do
    %{state |
      dir_y: !state.dir_y,
      y: 7,
      color: rand_color()
    }
  end

  def check_y(state), do: state

  def rand_color do
    :rand.uniform(7)
  end
end
