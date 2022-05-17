%%This class controls the location and movement of the robots and bricks
%%within the animated wall building

classdef Test < handle
properties
%GUI variables
estop;
startRobot;


%Setup Robots Variables
robot;      %UR3
robotBase;  %UR3 Base Location

 
%Setup Bricks Variables
cups;
cupEndLocations;
cupStartLocations;

%Animation Variables
qMatrix;

end

methods
function self = Test()

    disp('setting up robots...');
    %% Animation setup
    % robot Location
    % cup start and end locations
    % ->getStartingPositions
    [cupStartLocations, cupEndLocations, robotBase] = self.getStartingPositions();

    %store the variables in the object
    self.robotBase = robotBase;
    self.cupStartLocations = cupStartLocations;
    self.cupEndLocations = cupEndLocations;

    %initiate the robots
    self.robot = IRB120(0,0,0);

    %make an array of cup
    for i = 1:3
        self.cups{i} = Thing("cup5",self.cupStartLocations{i});
    end

    %get the moves for each robot and whether the brick is picked up
    [cup, cupMoving, cupTR] = getMoves(self);

    %convert the transforms to joint positions for each move per robot
    qMatrix = self.transformMoves(self.robot, cupTR);
    self.qMatrix = qMatrix;

    % reset the view range
    axis([-3 3 -3 3 0 2.7]);
    view(50,30);
%     disp('Start building wall?');
%     pause();
%     disp('building wall...');

    self.startRobot = 0;
    self.estop = 0;
    self.robotRunning = 1;
    self.getSimulationGUI;

    %animate the movement for each robot
    for i = 1:3
        self.animateRobot(self.robot.model, self.qMatrix{i}, cup{i}, cupMoving{i});
%     pause
    end
end

function qMatrix = transformMoves(~,robot, cupTR)
    steps = 100; %%more steps ->slower code and movement
    joints=7;
    qCurrent = zeros(1,joints);
    iterations = 3; %%number of moves. change for number of moves required
    qMatrix = cell(iterations, joints);
    for i = 1:iterations
        if cupTR{i} == 0
            qMatrix{i} = 0;
        else
            qGoal = robot.model.ikcon(cupTR{i}, qCurrent);
            s = lspb(0, 1, steps);
            qMatrix{i} = zeros(steps, joints);
            
            for j = 1:steps
                qMatrix{i}(j, :) = (1-s(j))*qCurrent + s(j)*qGoal;
            end
            qCurrent = qGoal;
        end
    end
end

function animateRobot(self,robot, qMatrix, cup, cupMoving  )
    %ANIMATEROBOTS This function makes the robots move
    %   This function takes the robots in use, Trapezoidal Velocity Profile,
    %   cup in use and whether the cup is to also be moved. It then uses
    %   animate to move the robot.
    
    while self.startRobot == 0
        pause(1);
    end
    if self.startRobot == 1
    steps = height(qMatrix);
    for i = 1:steps

        %animate robot motion
        if size(qMatrix) > 1
            animate(robot, qMatrix(i, :));
        end
        %animate brick motion
        if cupMoving == true
            newPos1 = robot.fkine(qMatrix(i, :));
            cup.updatePosition(newPos1);
        end

        while self.estop == 1
        % this pauses the code while the estop is pressed
        pause(1);
        while self.robotRunning == 0
        pause(1);
        end
        end
        
        drawnow()
    end
    end
end
end
end