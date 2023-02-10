defmodule ToyRobotSimulator.ToyRobotSimulatorTest do
  use ExUnit.Case

  alias ToyRobotSimulator.ToyRobotSimulator
  doctest ToyRobotSimulator

  describe "init/1" do
    test "call init with correct params" do
      state = {2, 4, :west}
      assert {:ok, pid} = ToyRobotSimulator.start_link(state)
      assert ToyRobotSimulator.report(pid) == state
    end

    test "call init to take default params" do
      {:ok, pid} = ToyRobotSimulator.start_link()
      assert ToyRobotSimulator.place(pid) == {0, 0, :north}
    end

    test "call init with invalid params" do
      {:ok, pid} = ToyRobotSimulator.start_link()
      assert ToyRobotSimulator.place(pid, {:zero, :zero, :north}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {0, :zero, :north}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {:zero, 0, :north}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {0, 0, "north"}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {5, 3, :north}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {2, 7, :north}) == {:error, :invalid_postion_or_facing_direction}
      assert ToyRobotSimulator.place(pid, {0, 0, :invalid_direction}) == {:error, :invalid_postion_or_facing_direction}
    end
  end

  describe "rotate toy" do
    test "left" do
      {:ok, pid} = ToyRobotSimulator.start_link()
      ToyRobotSimulator.place(pid)
      assert {0, 0, :west} = ToyRobotSimulator.left(pid)
    end

    test "right" do
      {:ok, pid} = ToyRobotSimulator.start_link()
      ToyRobotSimulator.place(pid)
      assert {0, 0, :east} = ToyRobotSimulator.right(pid)
    end
  end

  describe "move toy" do
    test "valid move" do
      {:ok, pid} = ToyRobotSimulator.start_link()
      ToyRobotSimulator.place(pid)
      assert {0, 1, :north} = ToyRobotSimulator.move(pid)
    end

    test "invalid move" do
      state = {0, 0, :south}
      {:ok, pid} = ToyRobotSimulator.start_link(state)
      assert ToyRobotSimulator.move(pid) == state
    end
  end
end
