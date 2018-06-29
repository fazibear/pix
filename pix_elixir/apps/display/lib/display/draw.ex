defmodule Display.Draw do
  @moduledoc """
  Helper functions for drawing symbols and chars
  """

  alias Display.Draw.Char

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
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end

  def dot(matrix, x, y, color) when x >= 0 and x <= 15 and y >= 0 and y <= 15 do
    List.update_at(matrix, y, &List.replace_at(&1, x, color))
  end

  def dot(matrix, _, _, _), do: matrix

  def symbol(matrix, data, x, y, c \\ 7)

  def symbol(matrix, {module, symbol}, x, y, c) when is_binary(symbol) do
    symbol(matrix, module.data_for(symbol), x, y, c)
  end

  def symbol(matrix, data, x, y, c) do
    data
    |> Enum.with_index()
    |> Enum.reduce(matrix, &process_line(&1, &2, %{x: x, y: y, c: c}))
  end

  def char(matrix, char, x, y, c \\ 7)
  def char(matrix, " ", _, _, _), do: matrix

  def char(matrix, char, x, y, c) do
    char
    |> Char.data_for()
    |> Enum.with_index()
    |> Enum.reduce(matrix, &process_line(&1, &2, %{x: x, y: y, c: c}))
  end

  defp process_line({line, idx}, matrix, data) do
    line
    |> Enum.with_index()
    |> Enum.reduce(matrix, &process_char(&1, &2, idx, data))
  end

  defp process_char({?\s, _x}, matrix, _y, _data), do: matrix

  defp process_char({char, x}, matrix, y, data) do
    dot(matrix, data.x + x, data.y + y, char_to_color(char, data.c))
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
