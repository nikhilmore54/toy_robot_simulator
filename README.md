# ToyRobotSimulator

  
## Introduction
This application simulates the working of a toy robot placed on a board of 5 x 5 tiles. The board has four sides named as per the four primary directions (North, East, South and West) and the co-ordinates of the board progress in ascending order from left to right (West to East) and from bottom to top (South to North). The robot is able to rotate at 90 degrees to left and right (i.e. counter-clockwise and clockwise respectively) and can move only one step in the direction it is currently facing. 

### Assumptions

The robot can be placed anywhere on the board, facing one of the above mentioned directions. 
 * If the position and direction of the robot are not passed, the robot is placed at the South-West corner (or 0,0) of the board facing North. 
* If the user wishes to place the robot on a predetermined tile, all three parameters i.e. the X position, the Y position and the direction that the robot faces should be mentioned. 
-- In case, malformed initial positioning parameters of the robot the robot is not placed on the board
-- If the robot is already on the board, you may also place the robot again to a new position or direction or both. If the parameters of the new robot location are invalid, the robot is not moved. 
  

## Installation

  The application is a CLI application. To run the application, you can do so in one of the following ways:
  

 1. Through `iex` prompt
 2. As a standalone application through command line. 

### 1. Through `iex` prompt
While in the root directory of the project, run `iex -S mix` in the shell/command prompt. 
Inside the `iex` prompt call 
```shell
> ToyRobotSimulator.main
```

### 2. As a standalone application in command line
For the first time, in the shell run 
```shell
$ mix escript.build
```
from the root of the project. This is a one time activity. 

From the next run just call  
```shell
$ ./toy_robot_simulator
```

## Running the application
The above two steps should be able to display to you the following welcome screen
```shell
Welcome to the Toy Robot simulator!

  

The simulator supports following commands:

  

left - Rotates the robot to the left

move - Moves the robot one position forward

place - Places the Robot into X,Y facing F (Default is 0,0,North). Where facing is: north, west, south or east. Format: "place [X,Y,F]". For example, "place" would place the robot on (0, 0) facing north and "place 3,1, west" would place the robot in the tile (3,1) facing west.

quit - Quits the simulator

report - The Toy Robot reports about its position

right - Rotates the robot to the right
```

Your application is now ready to run. You may follow the instructions shown in the help banner as above to place and move your robot. 