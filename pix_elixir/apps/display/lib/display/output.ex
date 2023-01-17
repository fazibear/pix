defmodule Display.Output do
  @moduledoc """
  Helper function related to display output
  """

  def current?(state, module, data) do
    if module == current(state) do
      display(output(), data)
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

  def data(data), do: display(output(), data)

  def display(nil, _), do: nil
  def display(_, nil), do: nil
  def display(out, data), do: data |> out.data()

  def output do
    Application.get_env(:display, :output)
  end
end
