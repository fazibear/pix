defmodule Display.Draw.Symbol do
  @moduledoc """
  Various symbols
  """

  def data_for("dot_0") do
    [
      ' c ',
      'ccc',
      ' c '
    ]
  end

  def data_for("dot_1") do
    [
      'c c',
      ' c ',
      'c c'
    ]
  end

  def data_for("dot_2") do
    [
      'cc',
      'cc'
    ]
  end

  def data_for("dot_3") do
    [
      ' c',
      'c '
    ]
  end

  def data_for("dot_4") do
    [
      'c ',
      ' c'
    ]
  end

  def data_for("crab_0") do
    [
      '  c     c  ',
      'c  c   c  c',
      'c ccccccc c',
      'ccc ccc ccc',
      'ccccccccccc',
      ' ccccccccc ',
      '  c     c  ',
      ' c       c '
    ]
  end

  def data_for("crab_1") do
    [
      '  c     c  ',
      '   c   c   ',
      '  ccccccc  ',
      ' cc ccc cc ',
      'ccccccccccc',
      'c ccccccc c',
      'c c     c c',
      '   cc cc   '
    ]
  end

  def data_for("sun_0") do
    [
      '  3  3  ',
      '        ',
      '3  33  3',
      '  3333  ',
      '  3333  ',
      '3  33  3',
      '        ',
      '  3  3  '
    ]
  end

  def data_for("sun_1") do
    [
      '        ',
      '  3  3  ',
      ' 3 33 3 ',
      '  3333  ',
      '  3333  ',
      ' 3 33 3 ',
      '  3  3  ',
      '        '
    ]
  end

  def data_for("moon") do
    [
      '777  ',
      '  77 ',
      '   77',
      '   77',
      '   77',
      '   77',
      '  77 ',
      '777  '
    ]
  end

  def data_for("cloud") do
    [
      '     777  ',
      '   777777 ',
      ' 777777777',
      '7777777777',
      '7777777777',
      '777777777 ',
      ' 77  77   '
    ]
  end

  def data_for("rain_0") do
    [
      '6 6 6   ',
      ' 6 6 6  ',
      '        ',
      '  6 6 6 ',
      '   6 6 6'
    ]
  end

  def data_for("rain_1") do
    [
      '        ',
      '6 6 6   ',
      ' 6 6 6  ',
      '        ',
      '  6 6 6 ',
      '   6 6 6'
    ]
  end

  def data_for("snow_0") do
    [
      '7  7  7 ',
      ' 7  7  7',
      '7  7  7 ',
      ' 7  7  7'
    ]
  end

  def data_for("snow_1") do
    [
      '  7  7  7',
      ' 7  7  7 ',
      '  7  7  7',
      ' 7  7  7 '
    ]
  end

  def data_for("thunder") do
    [
      '1       ',
      ' 1   1  ',
      '  1 1 1 ',
      '   1   1',
      '        1'
    ]
  end

  def data_for("coin") do
    [
      ' cc ',
      'cccc',
      'cccc',
      ' cc '
    ]
  end

  def data_for("note") do
    [
      '   ccc ',
      '  c   c',
      '  c   c',
      '  c   c',
      '  c cc ',
      'cc  cc ',
      'cc     '
    ]
  end
end
