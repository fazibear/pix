defmodule Pix.Display do
  use GenStage

  alias Pix.Draw

  @timeout 5000

  def start_link(subscribers) do
    state = %{
      subscribers: subscribers,
      current_subscriber: Pix.Features.Random,
      screen: Draw.empty(),
      subscribers_data: %{},
    }

    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    send self(), :random
    {:producer_consumer, state, subscribe_to: state.subscribers}
  end

  def handle_info(:random, state) do
    state = state
    |> Map.put(:current_subscriber, Enum.random(state.subscribers))

    Process.send_after(self(), :random, @timeout)

    {:noreply, [], state}
  end


  def handle_events(events, _from, state) do
    {events, state} = Enum.reduce(events, {[], state}, &process_events/2)

    {:noreply, events, state}
  end

  defp process_events({key, value}, {events, state}) do

    state = Map.put(state, :subscribers_data, update_subscribers_data(state.subscribers_data, key, value))
    events = events ++ if key == state.current_subscriber, do: [value], else: []

    {events, state}
  end

  defp update_subscribers_data(subscribers_data, key, value) do
    subscribers_data
    |> Map.put(key, value)
  end
end
