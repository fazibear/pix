defmodule TerminalTest do
  use ExUnit.Case
  doctest Terminal

  test "greets the world" do
    assert Terminal.hello() == :world
  end
end
