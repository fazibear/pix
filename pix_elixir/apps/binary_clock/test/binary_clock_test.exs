defmodule BinaryClockTest do
  use ExUnit.Case
  doctest BinaryClock

  test "greets the world" do
    assert BinaryClock.hello() == :world
  end
end
