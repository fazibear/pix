defmodule Display.Output do
  @moduledoc """
  Helper function related to display output
  """

  def data(state, module, data) do
    if module == current(state) do
      current_output().data(data)
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

  def current_output do
    Application.get_env(:display, :output)
  end
end
