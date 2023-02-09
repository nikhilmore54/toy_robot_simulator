defmodule ToyRobotSimulator.ToyRobotSimulator do
  @moduledoc """
  Documentation for `ToyRobotSimulator`.
  """

  use GenServer

  @turn_left %{
    north: :west,
    west: :south,
    south: :east,
    east: :north
  }

  @turn_right %{
    north: :east,
    east: :south,
    south: :west,
    west: :north
  }

  def start_link(state \\ {0, 0, :north}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def move(pid), do: GenServer.call(pid, :move)
  def left(pid), do: GenServer.call(pid, :left)
  def right(pid), do: GenServer.call(pid, :right)
  def report(pid), do: GenServer.call(pid, :report)

  def init({position_x, position_y, facing_direction} = state) do
    case {position_x in 0..4, position_y in 0..4, facing_direction in Map.keys(@turn_left)} do
      {true, true, true} ->
          {:ok, state}
      _other ->
      {:error, :invalid_params}
    end
  end

  def handle_call(:move, _from, {position_x, position_y, facing_direction} = state) do
    {position_x, position_y, facing_direction} =
      case facing_direction do
        :north -> {position_x, position_y + 1, facing_direction}
        :east -> {position_x + 1, position_y, facing_direction}
        :south -> {position_x, position_y - 1, facing_direction}
        :west -> {position_x - 1, position_y, facing_direction}
      end

    if position_x in 0..4 and position_y in 0..4 do
      state = {position_x, position_y, facing_direction}
      {:reply, state, state}
    else
      {:reply, state, state}
    end
  end

  def handle_call(:left, _from, {position_x, position_y, facing_direction}) do
    state = {position_x, position_y, Map.get(@turn_left, facing_direction)}
    {:reply, state, state}
  end

  def handle_call(:right, _from, {position_x, position_y, facing_direction}) do
    state = {position_x, position_y, Map.get(@turn_right, facing_direction)}
    {:reply, state, state}
  end

  def handle_call(:report, _from, state) do
    {:reply, state, state}
  end
end
