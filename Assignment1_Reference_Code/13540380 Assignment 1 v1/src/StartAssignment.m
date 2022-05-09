function StartAssignment()
%This is the 'main'function for my Lab Assignment 1, running this code will
%run everything i have done

%These functions are used to make the MATLAB environment more useable - WHY ON EARTH IS THIS CAMERA CONTROL NOT ENABLED BY DEFAULT!
close all; clear all; clc
Axis_Control = gca;
Axis_Control.Clipping = "off";
set(Axis_Control,'CameraViewAngleMode','Manual');

%Robot Base positions
ur3Pos = [-0.5,0,0,0]; %(xPos,yPos,zPos,zYaw[degrees])
ur5Pos = [0.5,0,0,180]; %(xPos,yPos,zPos,zYaw[degrees])

%This will build all the necessary objects for the robot environment
Environment(ur3Pos,ur5Pos);


%This builds the 2 robots and then moves them simultaneously to the brick locations specified
MoveRobots(ur3Pos,ur5Pos);

end