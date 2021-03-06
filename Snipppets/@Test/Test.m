%%This class controls the location and movement of the robots and bricks
%%within the animated wall building

classdef Test < handle
properties
%GUI variables
estop;
startRobot;
robotRunning; %stop animation from continuing after estop till continue is pressed
orderReady;
%         order2Ready;
%         order3Ready;

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

    disp('setting up robot...');
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
    self.robot = IRB120(1, 0.2, 1.0);

    self.robot.advancedTeach;
    
    %make an array of cup
    for j = 1:3
        self.cups{j} = Thing("cup5",self.cupStartLocations{j});
    end

    %get the moves for each robot and whether the brick is picked up
    [cup, cupMoving, cupTR] = getMoves(self);

    %convert the transforms to joint positions for each move per robot
    qMatrix = self.transformMoves(self.robot, cupTR);
    self.qMatrix = qMatrix;

    % reset the view range
    axis([-3 3 -3 3 0 2.5]);

    %--------GUI properties
    self.estop = 0;
    self.robotRunning = 1;
    self.startRobot = 0;
    self.orderReady = 0;


    self.getSimulationGUI;
    %------------------------



    %-----------Loop for cups
    while 1
        switch self.orderReady
            case 0
                pause(1);
            case 1

                    %animate the movement for each robot
                    for k = 1:3
                        self.animateRobot(self.robot.model, self.qMatrix{k}, cup{k}, cupMoving{k});
                    end
                    self.orderReady = 0;
                    self.startRobot = 0;
                    self.robotRunning = 0; 
            case 2
                    %animate the movement for each robot
                    for l = 1:3
                        self.animateRobot(self.robot.model, self.qMatrix{l}, cup{l}, cupMoving{l});
                    end
                    self.orderReady = 0;
                    self.startRobot = 0;
                    self.robotRunning = 0; 
            case 3
                    %animate the movement for each robot
                    for h = 1:3
                        self.animateRobot(self.robot.model, self.qMatrix{h}, cup{h}, cupMoving{h});
                        %     pause
                    end 
                    self.orderReady = 0;
                    self.startRobot = 0;
                    self.robotRunning = 0; 
        end
    end
end

function qMatrix = transformMoves(~,robot, cupTR)
    steps = 100; %%more steps ->slower code and movement
    joints=7;
    qCurrent = zeros(1,joints);
    iterations = 3; %%number of moves. change for number of moves required
    qMatrix = cell(iterations, joints);
    disp(cupTR{1});
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
                newPos1 = robot.fkine(qMatrix(i, :)); % THIS IS WHERE WE MASK THE CUP YAW SO IT IS ALWAYS UPRIGHT
                %                         disp(newPos1)
                cup.updatePosition(newPos1*transl(0,0,-0.1));
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