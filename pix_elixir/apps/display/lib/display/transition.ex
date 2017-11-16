defmodule Display.Transition do
  @moduledoc """
  Animate between each feature
  """

  alias Display.{
    Draw,
    TransitionRules
  }

  def update(%{current_subscriber: _} = state) do
    old = state.current_subscriber
    new = Enum.at(state.subscribers, state.current_subscriber_index)

    case {old, new} do
      {nil, new} ->
        Map.put(state, :current_subscriber, new)

      {old, new} when old == new ->
        state

      _ ->
        state
        |> Map.put(:current_subscriber, :transition)
        |> Map.put(:transition, %{
             old: old,
             new: new,
             type: Enum.random([:line, :column]),
             steps: Enum.random(TransitionRules.all())
           })
    end
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
    steps
    |> Enum.map(&process_line(&1, state))
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

  defp line_data("o", %{subscribers_data: subscribers_data, transition: transition}),
    do: subscribers_data[transition.old]

  defp line_data(_, %{subscribers_data: subscribers_data, transition: transition}),
    do: subscribers_data[transition.new]

  defp line_data(_, _), do: Draw.empty()

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

  defp transpose?(nil, _), do: nil
  defp transpose?(data, :line), do: data
  defp transpose?(data, :column), do: transpose(data)
  defp transpose?(_, _), do: Draw.empty()

  defp transpose([[x | xs] | xss]) do
    [
      [x | for([h | _] <- xss, do: h)]
      | transpose([xs | for([_ | t] <- xss, do: t)])
    ]
  end

  defp transpose([[] | xss]), do: transpose(xss)
  defp transpose([]), do: []
end
