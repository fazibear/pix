defmodule Display do
  @moduledoc """
  Display application

  Subscribe to featrures apps, generates output
  """

  use GenServer

  alias Display.{
    Cycle,
    Output,
    Subscriber,
    Transition
  }

  @default_change_timeout 5 * 1000
  @transition_timeout 20

  def remove(subscriber) do
    GenServer.cast(__MODULE__, {:remove, subscriber})
  end

  def update(module, data) do
    GenServer.cast(__MODULE__, {:update, module, data})
  end

  def time(module, time) do
    GenServer.cast(__MODULE__, {:time, module, time})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{time: %{}, subscribers: %{}}, name: __MODULE__)
  end

  def init(state) do
    send(self(), :change)

    {:ok, state}
  end

  def handle_cast({:time, module, time}, state) do
    {:noreply, put_in(state.time[module], time)}
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
    if state.current_subscriber do
      Process.send_after(self(), :change, change_time(state))
    else
      send(self(), :change)
    end

    {:noreply, state}
  end

  defp change_time(state) do
    state
    |> Map.get(:time, %{})
    |> Map.get(state.current_subscriber, @default_change_timeout)
  end
end
