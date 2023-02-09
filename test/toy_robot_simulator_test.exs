defmodule ToyRobotSimulatorTest do
  use ExUnit.Case
  doctest ToyRobotSimulator

  test "greets the world" do
    assert ToyRobotSimulator.hello() == :world
  end
end
