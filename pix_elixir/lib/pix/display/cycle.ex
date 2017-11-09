defmodule Pix.Display.Cycle do
  def cycle_subscribers(state) do
    if current_subscriber_index(state) == length(state.subscribers) - 1 do
      %{state | current_subscriber_index: 0 }
    else
      %{state | current_subscriber_index: current_subscriber_index(state) + 1 }
    end
  end

  def update_suscriber(state) do
    Map.put(
      state,
      :current_subscriber,
      Enum.at(state.subscribers, state.current_subscriber_index)
    )
  end

  def current_subscriber_index(state) do
    Map.get(state, :current_subscriber_index, -1)
  end
end
