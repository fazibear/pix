defmodule LedsTest do
  use ExUnit.Case
  doctest Leds

  test "greets the world" do
    assert Leds.hello() == :world
  end
end
