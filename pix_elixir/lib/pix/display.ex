defmodule Pix.Display do
  use GenStage

  alias Pix.Draw
  alias Pix.Display.{
    Cycle,
    Subscribers,
  }

  @change_timeout 5000
  @transition_timeout 200

  def start_link(subscribers) do
    state = %{
      subscribers: subscribers,
    }

    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    send self(), :change
    {:producer_consumer, state, subscribe_to: state.subscribers}
  end

  def handle_info(:change, state) do
    state = state
            |> Cycle.cycle_subscribers()
            |> Cycle.update_suscriber()

    Process.send_after(self(), :change, @change_timeout)

    send self(), :transition

    {:noreply, [], state}
  end

  def handle_info(:transition, %{current_subscriber: {:transition, old, new}} = state) do
    Process.send_after(self(), :transition, @transition_timeout)

    state = state
            |> Map.put(:current_subscriber, new)
            |> IO.inspect

    {:noreply, [], state}
  end

  def handle_info(:transition, state) do
    {:noreply, [], state}
  end

  def handle_events(events, _from, state) do
    {events, state} = Subscribers.process_events(events, state)

    {:noreply, events, state}
  end
end
