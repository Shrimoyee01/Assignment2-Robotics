classdef MoveRobots < handle
    %This class will move the two robots psudo-simultaneously

    properties
        %global class variables
        UR3Pos_;
        UR5Pos_;
    end

    methods
        function self = MoveRobots(UR3Pos,UR5Pos)
            %This function will build the necessary functionality to move the robots

            self.UR3Pos_= UR3Pos;
            self.UR5Pos_= UR5Pos;

            %Next Function
            self.MoveAboutBricks();






        end

        function MoveAboutBricks(self)
            %Move the robot arms to the positions of the bricks


            UR3Pos = self.UR3Pos_;
            UR5Pos = self.UR5Pos_;

            UR3BrickList = CreateBricks(UR3Pos,UR5Pos).ReturnUR3BrickList;
            UR5BrickList = CreateBricks(UR3Pos,UR5Pos).ReturnUR5BrickList;



            workspace = [-4 4 -4 4 0 3];

            % Options
            interpolation = 2;                                                         % 1 = Quintic Polynomial, 2 = Trapezoidal Velocity
            steps = 80;                                                                % Specify no. of steps

            % Load Model
            robotUR3 = UR3(false, UR3Pos(1,1), UR3Pos(1,2), UR3Pos(1,3), UR3Pos(1,4)).model;
            robotUR5 = LinearUR5(false, UR5Pos(1,1), UR5Pos(1,2), UR5Pos(1,3), UR5Pos(1,4)).model;

            currentUR3EE = zeros(1,6);
            currentUR5EE = zeros(1,7);

            disp("Press Enter To Continue");
            pause;

            for i = 1:9                
                
                % Load Current End Effector Positons
                robotUR3.fkine(currentUR3EE);
                robotUR5.fkine(currentUR5EE);
                
                % For UR3 - Define End-Effector transformation, use inverse kinematics to get joint angles
                q0 = zeros(1,6);
                T1 = transl(0.8,0.3,0.6);                                                  % Create translation matrix
                q1 = robotUR3.ikcon(T1,q0);                                                        % Derive joint angles for required end-effector transformation
                T2 = transl(UR3BrickList{1,i}(1,1),UR3BrickList{1,i}(1,2),UR3BrickList{1,i}(1,3)+0.1);                                                   % Define a translation matrix
                q2 = robotUR3.ikcon(T2,q1);                                                        % Use inverse kinematics to get the joint angles

                % For UR5 - Define End-Effector transformation, use inverse kinematics to get joint angles
                q0L = zeros(1,7);
                T1L = transl(0.8,0.3,0.6);                                                  % Create translation matrix
                q1L = robotUR5.ikcon(T1L,q0L);                                                        % Derive joint angles for required end-effector transformation
                T2L = transl(UR5BrickList{1,i}(1,1),UR5BrickList{1,i}(1,2),UR5BrickList{1,i}(1,3)+0.1);                                                   % Define a translation matrix
                q2L = robotUR5.ikcon(T2L,q1L);

                % For UR3 - Interpolate joint angles, also calculate relative velocity, accleration
                qMatrix = jtraj(q1,q2,steps);
                switch interpolation
                    case 1
                        qMatrix = jtraj(q1,q2,steps);
                    case 2
                        s = lspb(0,1,steps);                                              % First, create the scalar function
                        qMatrix = nan(steps,6);                                             % Create memory allocation for variables
                        for i = 1:steps
                            qMatrix(i,:) = (1-s(i))*q1 + s(i)*q2;                    % Generate interpolated joint angles
                        end
                    otherwise
                        error('interpolation = 1 for Quintic Polynomial, or 2 for Trapezoidal Velocity')
                end

                % For UR5 - Interpolate joint angles, also calculate relative velocity, accleration
                qMatrixL = jtraj(q1L,q2L,steps);
                switch interpolation
                    case 1
                        qMatrixL = jtraj(q1L,q2L,steps);
                    case 2
                        sL = lspb(0,1,steps);                                              % First, create the scalar function
                        qMatrixL = nan(steps,7);                                             % Create memory allocation for variables
                        for i = 1:steps
                            qMatrixL(i,:) = (1-s(i))*q1L + s(i)*q2L;                    % Generate interpolated joint angles
                        end
                    otherwise
                        error('interpolation = 1 for Quintic Polynomial, or 2 for Trapezoidal Velocity')
                end


                %Run both robots simultaneously
                for i = 1:steps

                    robotUR3.plot(qMatrix(i,:),'workspace',workspace, 'scale', 0.15, 'noarrow');
                    robotUR5.plot(qMatrixL(i,:),'workspace',workspace, 'scale', 0.15, 'noarrow');

                end

                robotUR3.fkine(qMatrix(:,:,end))
                robotUR5.fkine(qMatrixL(:,:,end))

                currentUR3EE = qMatrix(:,:,end);
                currentUR5EE = qMatrixL(:,:,end);
                
                disp("Press Enter To Continue To Moving To The Next Brick");
                pause;


                %             % For UR3 - Plot the results
                %             robotUR3.plot(qMatrix,'workspace',workspace, 'scale', 0.15, 'noarrow');
                %
                %             % For UR5 - Plot the results
                %             robotUR5.plot(qMatrixL,'workspace',workspace, 'scale', 0.15, 'noarrow');
            end

        end
    end
end