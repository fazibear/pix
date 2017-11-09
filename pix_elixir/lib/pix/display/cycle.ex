defmodule Pix.Display.Cycle do
  def cycle_subscribers(state) do
    if current_subscriber_index(state) == length(state.subscribers) - 1 do
      reset_index(state)
    else
      increment_index(state)
    end
  end

  def update_suscriber(%{current_subscriber: _} = state) do
    Map.put(
      state,
      :current_subscriber,
      {
        :transition,
        state.current_subscriber,
        Enum.at(state.subscribers, state.current_subscriber_index)
      }
    )
  end

  def update_suscriber(state) do
    Map.put(
      state,
      :current_subscriber,
      Enum.at(state.subscribers, state.current_subscriber_index)
    )
  end

  def current_subscriber_index(state) do
    Map.get(
      state,
      :current_subscriber_index,
      -1
    )
  end

  def reset_index(state) do
    Map.put(
      state,
      :current_subscriber_index,
      0
    )
  end

  def increment_index(state) do
    Map.put(
      state,
      :current_subscriber_index,
      current_subscriber_index(state) + 1
    )
  end
end
