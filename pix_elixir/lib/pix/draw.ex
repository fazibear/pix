defmodule Pix.Draw do

  alias Pix.Draw.{
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
      "dot0" -> Symbol.data_dot_0()
      "dot1" -> Symbol.data_dot_1()
      _ -> []
    end
  end

  defp process_line({line, idx}, matrix, data) do
    line
    |> Enum.with_index
    |> Enum.reduce(matrix, &process_char(&1, &2, idx, data))
  end

  defp process_char({char, idx}, matrix, line_idx, data) do
    matrix
    |> char_to_pix(char, idx, line_idx, data)
  end

  defp char_to_pix(matrix, char, x, y, data) do
    case char do
      ?c -> dot(matrix, data.x + x, data.y + y, data.c)
      ?1 -> dot(matrix, data.x + x, data.y + y, 1)
      ?2 -> dot(matrix, data.x + x, data.y + y, 2)
      ?3 -> dot(matrix, data.x + x, data.y + y, 3)
      ?4 -> dot(matrix, data.x + x, data.y + y, 4)
      ?5 -> dot(matrix, data.x + x, data.y + y, 5)
      ?6 -> dot(matrix, data.x + x, data.y + y, 6)
      ?7 -> dot(matrix, data.x + x, data.y + y, 7)
      _ -> matrix
    end
  end
end
