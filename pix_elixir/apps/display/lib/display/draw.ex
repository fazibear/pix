defmodule Display.Draw do

  alias Display.Draw.{
    Digit,
    Symbol
  }

  def empty do
    [
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    ]
  end

  def dot(matrix, x, y, color) do
    matrix
    |> List.update_at(y, &List.replace_at(&1, x, color))
  end

  def char(matrix, char, x, y, c \\ 1) do
    char
    |> char_to_data
    |> Enum.with_index
    |> Enum.reduce(matrix, &process_line(&1, &2, %{x: x, y: y, c: c}))
  end

  defp char_to_data(char) do
    case char do
      "1" -> Digit.data_1()
      "2" -> Digit.data_2()
      "3" -> Digit.data_3()
      "4" -> Digit.data_4()
      "5" -> Digit.data_5()
      "6" -> Digit.data_6()
      "7" -> Digit.data_7()
      "8" -> Digit.data_8()
      "9" -> Digit.data_9()
      "0" -> Digit.data_0()
      "dot_0" -> Symbol.data_dot_0()
      "dot_1" -> Symbol.data_dot_1()
      "dot_2" -> Symbol.data_dot_2()
      "dot_3" -> Symbol.data_dot_3()
      "dot_4" -> Symbol.data_dot_4()
      _ -> []
    end
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

  defp char_to_color(char, color) do
    case char do
      ?c -> color
      ?1 -> 1
      ?2 -> 2
      ?3 -> 3
      ?4 -> 4
      ?5 -> 5
      ?6 -> 6
      ?7 -> 7
      _ -> 0
    end
  end
end
