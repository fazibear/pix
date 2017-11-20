defmodule Display.Subscriber do
  @moduledoc """
  Helper function related to subscriber
  """

  def add(state, subscriber) do
    %{state | subscribers: state.subscribers ++ [subscriber]}
  end

  def remove(state, subscriber) do
    %{state | subscribers: List.delete(state.subscribers, subscriber)}
  end

  def update(%{subscribers_data: _} = state, module, data) do
    put_in(state.subscribers_data[module], data)
  end

  def update(state, module, data) do
    update(
      Map.put(state, :subscribers_data, %{}),
      module,
      data
    )
  end

  def output(state, module, data) do
    if module == current(state) do
      data
    end
  end

  defp current(state) do
    Map.get(
      state,
      :current_subscriber,
      nil
    )
  end
end
