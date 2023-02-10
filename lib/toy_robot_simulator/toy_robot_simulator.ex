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

  def move(pid), do: GenServer.cast(pid, :move)
  def left(pid), do: GenServer.cast(pid, :left)
  def right(pid), do: GenServer.cast(pid, :right)
  def report(pid), do: GenServer.call(pid, :report)

  def init({position_x, position_y, facing_direction} = state) do
    case {position_x in 0..4, position_y in 0..4, facing_direction in Map.keys(@turn_left)} do
      {true, true, true} ->
          {:ok, state}
      _other ->
      {:error, :invalid_params}
    end
  end

  def handle_cast(:move, {position_x, position_y, facing_direction} = state) do
    {position_x, position_y, facing_direction} =
      case facing_direction do
        :north -> {position_x, position_y + 1, facing_direction}
        :east -> {position_x + 1, position_y, facing_direction}
        :south -> {position_x, position_y - 1, facing_direction}
        :west -> {position_x - 1, position_y, facing_direction}
      end

    if position_x in 0..4 and position_y in 0..4 do
      state = {position_x, position_y, facing_direction}
      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_cast(:left, {position_x, position_y, facing_direction}) do
    state = {position_x, position_y, Map.get(@turn_left, facing_direction)}
    {:noreply, state}
  end

  def handle_cast(:right, {position_x, position_y, facing_direction}) do
    state = {position_x, position_y, Map.get(@turn_right, facing_direction)}
    {:noreply, state}
  end

  def handle_call(:report, _from, state) do
    {:reply, state, state}
  end
end
