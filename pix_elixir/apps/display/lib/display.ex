defmodule Display do
  use GenStage

  alias Display.{
    Cycle,
    Subscriber,
    Transition,
  }

  @change_timeout 5000
  @transition_timeout 20

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, %{subscribers: []}, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :change, 100)

    {:producer_consumer, state}
  end

  def subscribe(subscriber) do
    if System.get_env("ONE") do
      if "Elixir.#{System.get_env("ONE")}" == Atom.to_string(subscriber) do
        GenStage.cast(__MODULE__, {:subscribe, subscriber})
      end
    else
      GenStage.cast(__MODULE__, {:subscribe, subscriber})
    end
  end

  def handle_cast({:subscribe, subscriber}, state) do
    {:noreply, [], Subscriber.add(subscriber, state)}
  end

  def handle_info(:change, state) do
    state = state
            |> Cycle.subscribers()
            |> Transition.update()

    Process.send_after(self(), :change, @change_timeout)

    send self(), :transition

    {:noreply, [], state}
  end

  def handle_info(:transition, %{current_subscriber: :transition} = state) do
    Process.send_after(self(), :transition, @transition_timeout)

    {events, state} = Transition.process(state)

    {:noreply, events, state}
  end

  def handle_info(:transition, state) do
    {:noreply, [], state}
  end

  def handle_events(events, _from, state) do
    {events, state} = Subscriber.process_events(events, state)

    {:noreply, events, state}
  end
end
