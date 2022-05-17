classdef MoveRobot < handle
    %MOVEROBOT Summary of this class goes here
    %   Detailed explanation goes here

    properties
        robot_;
        estop_;
        isHoldingCup_; %%if 

        %%initialise in the constructor the moves sequence -> 
        % cup 1 moves -> start to end location. brick wall moves 
        % 
    end

    methods
%%constructor
        function self = MoveRobot(nextEE)

            robot = IRB120(1,0.2,1.0).model;
            IRBEE = zeros(1,7);
            robot.fkine(IRBEE); 
            currentEE = robot.fkine(IRBEE);

            EEx = currentEE(1,4);
            EEy = currentEE(2,4);
            EEz = currentEE(3,4);

            EEx2 = nextEE(1);
            EEy2 = nextEE(2);
            EEz2 = nextEE(3);

            disp("Press Enter To Pick Up Coffee");
            pause;

            interpolation = 2;                                                         % 1 = Quintic Polynomial, 2 = Trapezoidal Velocity
            steps = 80;

            q0L = zeros(1,7);
            T1L = transl(EEx,EEy,EEz);                                                  % Create translation matrix
            q1L = robot.ikcon(T1L,q0L);                                                        % Derive joint angles for required end-effector transformation
            T2L = transl(EEx2,EEy2,EEz2);                                                   % Define a translation matrix
            q2L = robot.ikcon(T2L,q1L);

            location1 = transl(1,0,0);
            cup1 = Thing("cup5",location1);

 
            % For UR5 - Interpolate joint angles, also calculate relative velocity, accleration
            qMatrixL = jtraj(q1L,q2L,steps);
            switch interpolation
                case 1
                    qMatrixL = jtraj(q1L,q2L,steps);
                case 2
                    s = lspb(0,1,steps);                                              % First, create the scalar function
                    qMatrixL = nan(steps,7);                                             % Create memory allocation for variables
                    for i = 1:steps
                        qMatrixL(i,:) = (1-s(i))*q1L + s(i)*q2L;                    % Generate interpolated joint angles
                    end
                otherwise
                    error('interpolation = 1 for Quintic Polynomial, or 2 for Trapezoidal Velocity')
            end

            for i = 1:steps
                robot.plot(qMatrixL(i,:),'workspace', [-3 3 -3 3 -0.001 3], 'scale', 0, 'noarrow','fps', 120);
                cup1position = robot.fkine(qMatrixL(i,:)); 
                cup1.updatePosition(cup1position);
            end

%             robot.fkine(qMatrixL(:,:,end));
        end


    end
%     function self = MoveRobot(nextEE)
%     end
end

