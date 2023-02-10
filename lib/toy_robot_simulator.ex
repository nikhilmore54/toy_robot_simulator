defmodule ToyRobotSimulator do
  alias ToyRobotSimulator.ToyRobotSimulator

  def main(args \\ []) do
    args
    |> parse_args()
    |> process_args()
  end

  defp parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [upcase: :boolean])
    params
  end

  def process_args(help: true) do
    print_help_message()
  end

  def process_args(_) do
    IO.puts("Welcome to the Toy Robot simulator!")
    print_help_message()
    receive_command()
  end

  @commands %{
    "quit" => "Quits the simulator",
    "place" =>
      "Places the Robot into X,Y facing F (Default is 0,0,North). " <>
        "Where facing is: north, west, south or east. " <>
        "Format: \"place [X,Y,F]\".",
    "report" => "The Toy Robot reports about its position",
    "left" => "Rotates the robot to the left",
    "right" => "Rotates the robot to the right",
    "move" => "Moves the robot one position forward"
  }

  defp receive_command() do
    {:ok, robot} = ToyRobotSimulator.start_link()
    receive_command(robot)
  end

  defp receive_command(robot) do
    IO.gets("> ")
    |> String.trim()
    |> String.downcase()
    |> String.split(" ")
    |> execute_command(robot)
  end

  defp execute_command(["place"], robot) do
    ToyRobotSimulator.place(robot)
    IO.puts("Robot placed successfully")
    receive_command(robot)
  end

  defp execute_command(["place" | params], robot) do
    case ToyRobotSimulator.place(robot, process_place_params(params)) do
      {_position_x, _position_y, _facing} ->
        IO.puts("Robot placed successfully")
        receive_command(robot)

      {:error, message} ->
        IO.puts(inspect(message))
        IO.puts("** The robot is not placed. Please check the parameters and try again.")
        receive_command(robot)
    end
  end

  defp execute_command(["left"], robot) do
    ToyRobotSimulator.left(robot)
    receive_command(robot)
  end

  defp execute_command(["right"], robot) do
    ToyRobotSimulator.right(robot)
    receive_command(robot)
  end

  defp execute_command(["move"], robot) do
    if {:error, :invalid_move} == ToyRobotSimulator.move(robot) do
      IO.puts "Your move will place the robot out of the board. The robot is not moved."
    end
    receive_command(robot)
  end

  defp execute_command(["report"], robot) do
    {x, y, facing} = ToyRobotSimulator.report(robot)
    IO.puts(String.upcase("#{x},#{y},#{facing}"))

    receive_command(robot)
  end

  defp execute_command(["quit"], _robot) do
    IO.puts("\nConnection lost")
  end

  defp execute_command(_unknown, robot) do
    IO.puts("\nInvalid command. I don't know what to do.")
    print_help_message()

    receive_command(robot)
  end

  defp process_place_params(params) do
    params = params |> Enum.join("") |> String.split(",") |> Enum.map(&String.trim/1)
       if 3 == length(params) do
       [x, y, facing] =  Enum.map(params, &String.trim/1)
      try do
        {String.to_integer(x), String.to_integer(y), String.to_atom(facing)}
      rescue
        _ ->
          IO.puts("Invalid parameters are passed, robot placed at the default initial position")
          nil
      end
    else
      IO.puts("Invalid parameters are passed, robot placed at the default initial position")
      nil
    end
  end

  defp print_help_message do
    IO.puts("\nThe simulator supports following commands:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)

    IO.puts("")
  end
end
