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

  def data(%{subscribers_data: _} = state, module, data) do
    put_in(state.subscribers_data[module], data)
  end

  def data(state, module, data) do
    data(
      Map.put(state, :subscribers_data, %{}),
      module,
      data
    )
  end
end
