defmodule RandomTest do
  use ExUnit.Case
  doctest Random

  test "greets the world" do
    assert Random.hello() == :world
  end
end
