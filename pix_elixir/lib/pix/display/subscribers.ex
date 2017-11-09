defmodule Pix.Display.Subscribers do
  def process_events(events, state) do
    Enum.reduce(events, {[], state}, &process_event/2)
  end

  def process_event({:data, key, value}, {events, state}) do
    state = put_in(state.subscribers_data[key], value)

    events = events ++ if key == state.current_subscriber, do: [value], else: []

    {events, state}
  end
end
