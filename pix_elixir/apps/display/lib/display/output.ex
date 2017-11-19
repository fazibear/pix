defmodule Display.Output do
  @moduledoc """
  Helper function related to display output
  """

  def data(state, module, data) do
    if module == current(state) do
      Terminal.data(data)
    end

    state
  end

  defp current(state) do
    Map.get(
      state,
      :current_subscriber,
      nil
    )
  end
end
