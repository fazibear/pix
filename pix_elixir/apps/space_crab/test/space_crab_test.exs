defmodule SpaceCrabTest do
  use ExUnit.Case
  doctest SpaceCrab

  test "greets the world" do
    assert SpaceCrab.hello() == :world
  end
end
