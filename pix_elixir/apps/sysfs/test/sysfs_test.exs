defmodule SysfsTest do
  use ExUnit.Case
  doctest Sysfs

  test "greets the world" do
    assert Sysfs.hello() == :world
  end
end
