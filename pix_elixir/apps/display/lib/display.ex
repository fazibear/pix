defmodule Display do
  @moduledoc """
  Display application

  Subscribe to featrures apps, generates output
  """

  use GenServer

  alias Display.{
    Cycle,
    Subscriber,
    Transition,
    Output
  }

  @change_timeout 5000
  @transition_timeout 20

  def remove(subscriber) do
    GenServer.cast(__MODULE__, {:remove, subscriber})
  end

  def update(module, data) do
    GenServer.cast(__MODULE__, {:update, module, data})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{subscribers: %{}}, name: __MODULE__)
  end

  def init(state) do
    send self(), :change

    {:ok, state}
  end

  def handle_cast({:remove, subscriber}, state) do
    {:noreply, Subscriber.remove(state, subscriber)}
  end

  def handle_cast({:update, module, data}, state) do
    state = Subscriber.update(state, module, data)

    state
    |> Subscriber.output(module, data)
    |> Output.data()

    {:noreply, state}
  end

  def handle_info(:change, state) do
    state =
      state
      |> Cycle.subscribers()
      |> Transition.update()

    if state.current_subscriber do
      Process.send_after(self(), :change, @change_timeout)
    else
      send(self(), :change)
    end

    send(self(), :transition)

    {:noreply, state}
  end

  def handle_info(:transition, %{current_subscriber: :transition} = state) do
    Process.send_after(self(), :transition, @transition_timeout)

    {state, output} = Transition.process(state)

    Output.data(output)

    {:noreply, state}
  end

  def handle_info(:transition, state) do
    {:noreply, state}
  end
end
