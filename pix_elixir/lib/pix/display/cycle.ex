defmodule Pix.Display.Cycle do
  def cycle_subscribers(state) do
    if state.current_subscriber_index == length(state.subscribers) - 1 do
      %{state | current_subscriber_index: 0 }
    else
      %{state | current_subscriber_index: state.current_subscriber_index + 1 }
    end
  end

  def update_suscriber(state) do
    Map.put(state, :current_subscriber, Enum.at(state.subscribers, state.current_subscriber_index))
  end
end
