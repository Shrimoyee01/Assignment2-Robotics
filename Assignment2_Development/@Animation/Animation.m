%ANIMATION This class controls the location and movement of the robots and 
%   bricks within the animated wall building

classdef Animation < handle
    properties
        %GUI variables
        estop; % estopbutton control
        startRobot; % stops animation from starting till start is pressed
        robotRunning; % stop animation from continuing after estop till continue is pressed
        orderReady; % stores which order is ready. If 0 no order is ready. Values can be 0-3

        %Setup Robots Variables
        robot;      %IRB120
        robotBase;  %IRB120 Base Location

        %Setup Cup Variables
        cups;
        cupEndLocations;
        cupStartLocations;

        %Setup Person Variables
        person;
        personStartLocation;
        personEndLocation;

        %Animation Variables
        qMatrix;
        orderNo;
    end

    methods
        function self = Animation()

            disp('setting up robot...');
            %% Animation setup
            % robot Location
            % cup start and end locations
            % ->getStartingPositions
            [cupStartLocations, cupEndLocations,personStartLocation, ...
                personEndLocation, robotBase] = self.getStartingPositions();

            %store the variables in the object
            self.robotBase = robotBase; % not used
            self.cupStartLocations = cupStartLocations; %cup starting locations
            self.cupEndLocations = cupEndLocations; 
            self.personStartLocation = personStartLocation;
            self.personEndLocation = personEndLocation;

            %initiate the robot
            robot = IRB120(1, 0.2, 1.03); % initalise the robot location
            self.robot = robot; %store robot in the class
            robot.advancedTeach; %opens advanced teach

            %make an array of cup
            for i = 1:3
                self.cups{i} = Thing("cup5",self.cupStartLocations{i});
            end

            %make an array of person
            for i = 1:3
                self.person{i} = Thing("person7",self.personStartLocation{i});
            end

            %get the moves for each robot and whether the brick is picked up
            [cup, cupMoving, person, personMoving, cupTR] = getMoves(self);

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

            self.getSimulationGUI; % starts the GUI for robot control
            %------------------------
            disp('WELCOME!');

            %-----------Loop for cups
            while 1
                switch self.orderReady
                    case 0
                        pause(1);
                    case 1
                        OrderNo = 1;
                        %animate the movement for each robot
                        for k = 1:4
                            self.animateRobot(self.robot.model, self.qMatrix{k}, cup{k}, cupMoving{k},person{k}, personMoving{k},OrderNo);
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                        disp("Order Number 1 delivered!");
                    case 2
                        %animate the movement for each robot
                        OrderNo = 2;
                        for l = 5:8
                            self.animateRobot(self.robot.model, self.qMatrix{l}, cup{l}, cupMoving{l},person{l}, personMoving{l},OrderNo);
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                        disp("Order Number 2 delivered!");
                    case 3
                        OrderNo = 3;
                        %animate the movement for each robot
                        for h = 9:12
                            self.animateRobot(self.robot.model, self.qMatrix{h}, cup{h}, cupMoving{h},person{h}, personMoving{h},OrderNo);
                            %     pause
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                        disp("Order Number 3 delivered!");
                end
            end
            %------------------------------------------------

        end


        function qMatrix = transformMoves(~,robot, cupTR)
            %TRANSFORMMOVES This function calculates the qMatrix
            %   This function takes the robot in use and calculates the 
            %   Trapezoidal Velocity Profile qMatrix

            % We ran out of time to replace this with RMRC or quintic
            % polynomial
            % Trap completes the movement quickly however it has jerk and
            % so is not appropriate for the use case. An alternative would
            % be quintic or s-curve trajectory planning

            steps = 50; %%more steps ->slower code and movement
            joints=7;
            qCurrent = zeros(1,joints);
            iterations = 12; %%number of moves. change for number of moves required
            qMatrix = cell(iterations, joints);
            for i = 1:iterations
                if cupTR{i} == 0
                    qMatrix{i} = 0;
                else
                    qGoal = robot.model.ikcon(cupTR{i}, qCurrent); % include joint limits with ikone
                    s = lspb(0, 1, steps); %polynomial distance from 0 to 1
                    qMatrix{i} = zeros(steps, joints);

                    for j = 1:steps
                        qMatrix{i}(j, :) = (1-s(j))*qCurrent + s(j)*qGoal;
                    end
                    qCurrent = qGoal;
                end
            end
        end


        function animateRobot(self,robot, qMatrix, cup, cupMoving, person, personMoving, OrderNo)
            %ANIMATEROBOTS This function makes the robot move
            %   This function takes the robot in use, Trapezoidal Velocity Profile,
            %   cup in use and whether the cup is to also be moved. It then uses
            %   animate to move the robot.
            %   when an order is ready it also moves the correct person
            %   forward to collect the cup

            % hard coded in get moves

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

                    %animate cup motion
                    if cupMoving == true
                        newPos1 = robot.fkine(qMatrix(i, :)); %find the robot ee position
                        newPos1 = newPos1*transl(0,0,-0.1); %drop the cup location slightly just cause it didnt work on my computer?
                        ee = newPos1(1:3,4); % THIS IS WHERE WE MASK THE CUP YAW SO IT IS ALWAYS UPRIGHT
                        cup.updatePosition(transl(ee));
                    end

                    %% animate person motion
                    if personMoving == true
                        %self.personEndLocation{i}
                        if i == 1
                            currentPos = self.personStartLocation{OrderNo};
                            currentPos = currentPos(1:3,4);
                            cupPos = transl( 0.5 ,0, 1.4); %%hard coded hand off position
                            cupPos = cupPos(1:3,4);

                        end

                        %For order 1
                        if OrderNo == 1
                            if i <= 25 % person moving towards the cup
                                matrix = [0.9/25;0;0]; %step the person is moving
                            end

                            if i > 25 %person moving back with the cup
                                matrix = [-0.9/25;0;0]; %step the person is moving
                                cupPos = cupPos+matrix; 
                                tester = transl(cupPos);%*transl(0,0,-0.25); %added a transl down so the cup is in hand
                                cup.updatePosition(tester); %moved the cup position by the same step as the person
                            end
                            currentPos = currentPos+matrix;
                            personPos = transl(currentPos);
                            person.updatePosition(personPos);
                        end

                        %For order 2
                        if OrderNo == 2
                            if i <= 15 %person moves forward
                                matrix = [0.9/15;0;0];
                            end

                            if i <= 30 && i > 15 %person moves to the side towards robot
                                matrix = [0;1.15/15;0];
                            end

                            if i <= 45 && i > 30 %person moves to the side away from robot
                                matrix = [0;-1.15/15;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);%*transl(0,0,-0.25); %added a transl down so the cup is in hand
                                cup.updatePosition(tester);
                            end

                            if i <=50 && i > 45 %person moves back
                                matrix = [-0.9/5;0;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);%*transl(0,0,-0.25); %added a transl down so the cup is in hand
                                cup.updatePosition(tester);
                            end

                            currentPos = currentPos+matrix;
                            personPos = transl(currentPos);
                            person.updatePosition(personPos);
                        end

                        %For order 3
                        if OrderNo == 3
                            if i <= 15
                                matrix = [0.9/15;0;0];
                            end

                            if i <= 30 && i > 15
                                matrix = [0;2.15/15;0];
                            end

                            if i <= 45 && i > 30
                                matrix = [0;-2.15/15;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);%*transl(0,0,-0.25); %added a transl down so the cup is in hand
                                cup.updatePosition(tester);
                            end

                            if i <= 50 && i > 45
                                matrix = [-0.9/5;0;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);%*transl(0,0,-0.25); %added a transl down so the cup is in hand
                                cup.updatePosition(tester);
                            end

                            currentPos = currentPos+matrix;
                            personPos = transl(currentPos);
                            person.updatePosition(personPos);
                        end

                    end

                    while self.estop == 1
                        % this pauses the code while the estop is pressed
                        pause(1);
                        while self.robotRunning == 0
                            pause(1); %continue button while loop
                        end
                    end

                    drawnow()
                end
            end
        end
    end
end