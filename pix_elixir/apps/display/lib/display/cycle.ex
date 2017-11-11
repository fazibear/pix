defmodule Display.Cycle do
  def subscribers(state) do
    if current_subscriber_index(state) >= length(state.subscribers) - 1 do
      reset_index(state)
    else
      increment_index(state)
    end
  end

  defp current_subscriber_index(state) do
    Map.get(
      state,
      :current_subscriber_index,
      0
    )
  end

  defp reset_index(state) do
    Map.put(
      state,
      :current_subscriber_index,
      0
    )
  end

  defp increment_index(state) do
    Map.put(
      state,
      :current_subscriber_index,
      current_subscriber_index(state) + 1
    )
  end
end
