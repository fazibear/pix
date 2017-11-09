defmodule Pix.Display.Transition do

  alias Pix.Draw
  alias Pix.Display.TransitionRules

  def update(%{current_subscriber: _} = state) do
    state
    |> Map.put(:current_subscriber, :transition)
    |> Map.put(:transition, %{
      old: state.current_subscriber,
      new: Enum.at(state.subscribers, state.current_subscriber_index),
      type: Enum.random([:line, :column]),
      steps: Enum.random(TransitionRules.all())
    })
  end

  def update(state) do
    Map.put(
      state,
      :current_subscriber,
      Enum.at(state.subscribers, state.current_subscriber_index)
    )
  end

  def process(%{transition: _} = state) do
    [current | rest] = state.transition.steps

    events = process_steps(current, state)
    state = update_state(state, rest)

    {[events], state}
  end

  defp process_steps(steps, state) do
    Enum.map(steps, &process_line(&1, state))
    |> transpose?(state.transition.type)
  end

  defp process_line(step, state) do
    {from, line} = String.next_grapheme(step)
    line = String.to_integer(line)

    Enum.at(
      from |> line_data(state) |> transpose?(state.transition.type),
      line
    )
  end

  defp line_data("o", state), do: state.subscribers_data[state.transition.old]
  defp line_data(_, state), do: state.subscribers_data[state.transition.new]

  defp update_state(state, rest) do
    case rest do
      [] ->
        state
        |> Map.put(:current_subscriber, state.transition.new)
        |> Map.delete(:transition)
      rest ->
        put_in(state.transition.steps, rest)
    end
  end

  defp transpose?(data, :line), do: data
  defp transpose?(data, :column), do: data |> transpose
  defp transpose?(data, _), do: Draw.empty()

  defp transpose([[x | xs] | xss]) do
    [[x | (for [h | _] <- xss, do: h)] | transpose([xs | (for [_ | t] <- xss, do: t)])]
  end
  defp transpose([[] | xss]), do: transpose(xss)
  defp transpose([]), do: []
end
