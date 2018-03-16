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

  def subscribe(subscriber) do
    GenServer.cast(__MODULE__, {:subscribe, subscriber})
  end

  def unsubscribe(subscriber) do
    GenServer.cast(__MODULE__, {:unsubscribe, subscriber})
  end

  def data(module, data) do
    GenServer.cast(__MODULE__, {:data, module, data})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{subscribers: []}, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :change, 100)

    {:ok, state}
  end

  def handle_cast({:subscribe, subscriber}, state) do
    {:noreply, Subscriber.add(state, subscriber)}
  end

  def handle_cast({:unsubscribe, subscriber}, state) do
    {:noreply, Subscriber.remove(state, subscriber)}
  end

  def handle_cast({:data, module, data}, state) do
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

    Process.send_after(self(), :change, @change_timeout)

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
