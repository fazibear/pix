defmodule DisplayTest do
  use ExUnit.Case
  doctest Display

  test "greets the world" do
    assert Display.hello() == :world
  end
end
