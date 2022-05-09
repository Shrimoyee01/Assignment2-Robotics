%%This class controls the location and movement of the robots and bricks
%%within the animated wall building

classdef Animation < handle
properties
%Setup Robots Variables
robot1;      %UR3
robot2;      %UR5
robot1Base;  %UR3 Base Location
robot2Base;  %UR5 Base Location
 
%Setup Bricks Variables
bricks;
brickWallLocations;
brickLocations;

%Animation Variables
qMatrix1;
qMatrix2;
end

methods
function self = Animation()

    disp('setting up robots...');
    %% Animation setup
    % UR3 Location
    % UR5 Location
    % Brick start and end locations
    % ->getStartingPositions
    [brickLocations, brickWallLocations, robot1Base, robot2Base] = self.getStartingPositions();

    %store the variables in the object
    self.robot1Base = robot1Base;
    self.robot2Base = robot2Base;
    self.brickLocations = brickLocations;
    self.brickWallLocations = brickWallLocations;

    %initiate the robots
    self.robot1 = UR3(robot1Base);
    self.robot2 = UR5(robot2Base);

    %make an array of bricks
    for i = 1:9
        self.bricks{i} = Brick(self.brickLocations{i});
    end

    %get the moves for each robot and whether the brick is picked up
    [brickR1, brickR2, brickMovingR1, brickMovingR2, brickTR1, brickTR2] = getWallMoves(self);

    %convert the transforms to joint positions for each move per robot
    qMatrix1 = self.transformMoves(1, self.robot1, brickTR1);
    self.qMatrix1 = qMatrix1;
    qMatrix2 = self.transformMoves(2, self.robot2, brickTR2);
    self.qMatrix2 = qMatrix2;

    % reset the view range
    axis([-3 3 -3 3 0 2.7]);
    view(50,30);
    disp('Start building wall?');
    pause();
    disp('building wall...');

    %animate the movement for each robot
    for i = 1:15
        self.animateRobots(self.robot1.model, self.robot2.model, self.qMatrix1{i}, ...
            self.qMatrix2{i}, brickR1{i}, brickMovingR1{i}, brickR2{i}, brickMovingR2{i});
    end
end

function qMatrix = transformMoves(~,botChoice,robot, brickTR)
    steps = 20;
    if botChoice == 1
        joints=6;
    elseif botChoice == 2
        %joints=7;
        joints=6;
    end
    qCurrent = zeros(1,joints);
    iterations = 15;
    qMatrix = cell(iterations, joints);
    for i = 1:iterations
        if brickTR{i} ==0
            qMatrix{i} = 0;
        else
            qGoal = robot.model.ikcon(brickTR{i}, qCurrent);
            s = lspb(0, 1, steps);

            if botChoice == 1
                qMatrix{i} = zeros(steps, 6);
            end

            if botChoice == 2
                qMatrix{i} = zeros(steps, 6);
            end

            for j = 1:steps
                qMatrix{i}(j, :) = (1-s(j))*qCurrent + s(j)*qGoal;
            end
            qCurrent = qGoal;
        end
    end
end

function animateRobots(~,robot1, robot2, qMatrix1, qMatrix2,brickR1,brickMovingR1, brickR2,brickMovingR2  )
    %ANIMATEROBOTS This function makes the robots move
    %   This function takes the robots in use, Trapezoidal Velocity Profile,
    %   brick in use and whether the brick is to also be moved. It then uses
    %   animate to move the robot.

    steps = height(qMatrix1);
    for i = 1:steps

        %animate robot1 motion
        if size(qMatrix1) > 1
            animate(robot1, qMatrix1(i, :));
        end
        %animate brick1 motion
        if brickMovingR1 == true
            newPos1 = robot1.fkine(qMatrix1(i, :));
            brickR1.updatePosition(newPos1);
        end
        %animate robot2 motion
        if size(qMatrix2) > 1
            animate(robot2, qMatrix2(i, :));
        end
        %animate brick2 motion
        if brickMovingR2 == true
            newPos2 = robot2.fkine(qMatrix2(i, :));
            brickR2.updatePosition(newPos2);
        end
        drawnow()
    end
end
end
end