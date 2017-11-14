defmodule Display.Draw do

  alias Display.Draw.{
    Char,
    Symbol
  }

  def empty do
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ]
  end

  def dot(matrix, x, y, color) do
    matrix
    |> List.update_at(y, &List.replace_at(&1, x, color))
  end

  def symbol(matrix, data, x, y, c \\ 1)

  def symbol(matrix, {module, fun}, x, y, c) when is_binary(fun) do
    symbol(matrix, apply(module, String.to_atom(fun), []), x, y, c)

  end

  def symbol(matrix, {module, fun}, x, y, c) when is_atom(fun) do
    symbol(matrix, apply(module, fun, []), x, y, c)
  end

  def symbol(matrix, data, x, y, c) do
    data
    |> Enum.with_index
    |> Enum.reduce(matrix, &process_line(&1, &2, %{x: x, y: y, c: c}))
  end

  def char(matrix, char, x, y, c \\ 1) do
    char
    |> char_to_data
    |> Enum.with_index
    |> Enum.reduce(matrix, &process_line(&1, &2, %{x: x, y: y, c: c}))
  end

  defp char_to_data(char) do
    apply(Char, String.to_atom("_#{char}"), [])
  end

  defp process_line({line, idx}, matrix, data) do
    line
    |> Enum.with_index
    |> Enum.reduce(matrix, &process_char(&1, &2, idx, data))
  end

  defp process_char({char, x}, matrix, y, data) do
    matrix
    |> dot(data.x + x, data.y + y, char_to_color(char, data.c))
  end

  defp char_to_color(?c, color), do: color
  defp char_to_color(?1, _), do: 1
  defp char_to_color(?2, _), do: 2
  defp char_to_color(?3, _), do: 3
  defp char_to_color(?4, _), do: 4
  defp char_to_color(?5, _), do: 5
  defp char_to_color(?6, _), do: 6
  defp char_to_color(?7, _), do: 7
  defp char_to_color(_, _), do: 0
end
