defmodule Display.Output do
  @moduledoc """
  Helper function related to display output
  """

  def current?(state, module, data) do
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

  def data(nil), do: nil
  def data(data), do: current_output().data(data)

  def current_output do
    Application.get_env(:display, :output)
  end
end
