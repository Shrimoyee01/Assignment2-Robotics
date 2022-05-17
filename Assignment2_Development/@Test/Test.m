%%This class controls the location and movement of the robots and bricks
%%within the animated wall building

classdef Test < handle
    properties
        %GUI variables
        estop; % estopbutton control
        startRobot; %stops animation from starting till start is pressed
        robotRunning; %stop animation from continuing after estop till continue is pressed
        orderReady;

        %Setup Robots Variables
        robot;      %UR3
        robotBase;  %UR3 Base Location


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
        function self = Test()

            disp('setting up robot...');
            %% Animation setup
            % robot Location
            % cup start and end locations
            % ->getStartingPositions
            [cupStartLocations, cupEndLocations,personStartLocation, personEndLocation, robotBase] = self.getStartingPositions();

            %store the variables in the object
            self.robotBase = robotBase;
            self.cupStartLocations = cupStartLocations;
            self.cupEndLocations = cupEndLocations;
            self.personStartLocation = personStartLocation;
            self.personEndLocation = personEndLocation;


            %initiate the robot
            robot = IRB120(1, 0.2, 1.03);
            self.robot = robot;
            robot.advancedTeach;


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


            self.getSimulationGUI;
            %------------------------



            %-----------Loop for cups
            while 1
                switch self.orderReady
                    case 0
                        pause(1);
                    case 1
                        disp("Order Number 1");
                        OrderNo = 1;
                        %animate the movement for each robot
                        for k = 1:4
                            self.animateRobot(self.robot.model, self.qMatrix{k}, cup{k}, cupMoving{k},person{k}, personMoving{k},OrderNo);
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                    case 2
                        %animate the movement for each robot
                        disp("Order Number 2");
                        OrderNo = 2;
                        for l = 5:8
                            self.animateRobot(self.robot.model, self.qMatrix{l}, cup{l}, cupMoving{l},person{l}, personMoving{l},OrderNo);
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                    case 3
                        disp("Order Number 3");
                        OrderNo = 3;
                        %animate the movement for each robot
                        for h = 9:12
                            self.animateRobot(self.robot.model, self.qMatrix{h}, cup{h}, cupMoving{h},person{h}, personMoving{h},OrderNo);
                            %     pause
                        end
                        self.orderReady = 0;
                        self.startRobot = 0;
                        self.robotRunning = 0;
                end
            end
        end

        function qMatrix = transformMoves(~,robot, cupTR)
            steps = 50; %%more steps ->slower code and movement
            joints=7;
            qCurrent = zeros(1,joints);
            iterations = 12; %%number of moves. change for number of moves required
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

        function animateRobot(self,robot, qMatrix, cup, cupMoving, person, personMoving, OrderNo)
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

                    %animate cup motion
                    if cupMoving == true
                        newPos1 = robot.fkine(qMatrix(i, :)); % THIS IS WHERE WE MASK THE CUP YAW SO IT IS ALWAYS UPRIGHT
                        newPos1 = newPos1*transl(0,0,-0.1);
                        ee = newPos1(1:3,4);
                        cup.updatePosition(transl(ee));
                    end

                    %animate person motion
                    if personMoving == true
                        %self.personEndLocation{i}
                        if i == 1
                            currentPos = self.personStartLocation{OrderNo};
                            currentPos = currentPos(1:3,4);
                            cupPos = transl( 0.5 ,0, 1.4);
                            cupPos = cupPos(1:3,4);

                        end

                        %For order 1
                        if OrderNo == 1
                            if i > 25
                                matrix = [-0.9/25;0;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);
                                cup.updatePosition(tester);
                            end

                            if i <= 25
                                matrix = [0.9/25;0;0];
                            end
                            currentPos = currentPos+matrix;
                            personPos = transl(currentPos);
                            person.updatePosition(personPos);
                        end

                        %For order 2
                        if OrderNo == 2
                            if i <= 15
                                matrix = [0.9/15;0;0];
                            end

                            if i <= 30 && i > 15
                                matrix = [0;1.15/15;0];
                            end

                            if i <= 45 && i > 30
                                matrix = [0;-1.15/15;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);
                                cup.updatePosition(tester);
                            end

                            if i <=50 && i > 45
                                matrix = [-0.9/5;0;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);
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
                                tester = transl(cupPos);
                                cup.updatePosition(tester);
                            end

                            if i <= 50 && i > 45
                                matrix = [-0.9/5;0;0];
                                cupPos = cupPos+matrix;
                                tester = transl(cupPos);
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
                            pause(1);
                        end
                    end

                    drawnow()
                end
            end
        end
    end
end