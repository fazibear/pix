defmodule Pix.Display.Transition do
  alias Pix.Display.TransitionRules

  def update(%{current_subscriber: _} = state) do
    state
    |> Map.put(:current_subscriber, :transition)
    |> Map.put(:transition, %{
      old: state.current_subscriber,
      new: Enum.at(state.subscribers, state.current_subscriber_index),
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

  def process(%{transition: transition} = state) do
    [current | rest] = transition.steps

    events = process_step(current, state)

    state = update_state(state, rest)

    {[events], state}
  end

  defp process_step(step, state) do
    Enum.map(step, &process_line(&1, state))
  end

  defp process_line("o" <> line, state) do
    Enum.at(
      state.subscribers_data[state.transition.old],
      String.to_integer(line)
    )
  end

  defp process_line("n" <> line, state) do
    Enum.at(
      state.subscribers_data[state.transition.new],
      String.to_integer(line)
    )
  end

  defp process_line(_, state) do
    []
  end

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
end
