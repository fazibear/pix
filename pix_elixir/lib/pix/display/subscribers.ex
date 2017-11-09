defmodule Pix.Display.Subscribers do
  def process_events(events, state) do
    Enum.reduce(events, {[], state}, &process_event/2)
  end

  def process_event({:data, key, value}, {events, %{subscribers_data: _} = state}) do
    state = put_in(state.subscribers_data[key], value)

    events = events ++ if key == current_subscriber(state), do: [value], else: []

    {events, state}
  end

  def process_event(event, {events, state}) do
    process_event(
      event,
      {
        events,
        Map.put(state, :subscribers_data, %{})
      }
    )
  end

  def current_subscriber(state) do
    Map.get(
      state,
      :current_subscriber,
      Enum.at(state.subscribers, 0)
    )
  end
end
