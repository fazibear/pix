defmodule Pix.Display do
  use GenStage

  alias Pix.Draw

  @change_timeout 5000
  @transition_timeout 200

  def start_link(subscribers) do
    state = %{
      subscribers: subscribers,
      current_subscriber: Pix.Features.Random,
      screen: Draw.empty(),
      subscribers_data: %{},
      current_transition: nil
    }

    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    send self(), :change
    {:producer_consumer, state, subscribe_to: state.subscribers}
  end

  def handle_info(:change, state) do
    state = state
    |> Map.put(:current_subscriber, Enum.random(state.subscribers))

    Process.send_after(self(), :change, @change_timeout)

    {:noreply, [], state}
  end

  def handle_info(:transition, state) do
    Process.send_after(self(), :transition, @transition_timeout)

    {:noreply, [], state}
  end

  def handle_events(events, _from, state) do
    {events, state} = Enum.reduce(events, {[], state}, &process_events/2)

    {:noreply, events, state}
  end

  defp process_events({:data, key, value}, {events, state}) do
    state = put_in(state.subscribers_data[key], value)

    events = events ++ if key == state.current_subscriber, do: [value], else: []

    {events, state}
  end
end
