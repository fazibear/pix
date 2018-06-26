defmodule Display.Subscriber do
  @moduledoc """
  Helper function related to subscriber
  """

  def remove(state, subscriber) do
    %{state | subscribers: Map.delete(state.subscribers, subscriber)}
  end

  def all(state) do
    state
    |> Map.get(:subscribers)
    |> Map.keys()
  end

  def update(%{subscribers: _} = state, module, data) do
    put_in(state.subscribers[module], data)
  end

  def update(state, module, data) do
    update(
      Map.put(state, :subscribers, %{}),
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
