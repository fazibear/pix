defmodule Pix.Display.Transition do
  def update(%{current_subscriber: _} = state) do
    state
    |> Map.put(:current_subscriber, :transition)
    |> Map.put(:transition, %{
      old: state.current_subscriber,
      new: Enum.at(state.subscribers, state.current_subscriber_index),
      steps: []
    })
  end

  def update(state) do
    Map.put(
      state,
      :current_subscriber,
      Enum.at(state.subscribers, state.current_subscriber_index)
    )
  end

  def finish(state) do
    state
    |> Map.put(:current_subscriber, state.transition.new)
    |> Map.delete(:transition)
  end
end
