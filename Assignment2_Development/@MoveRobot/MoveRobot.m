classdef MoveRobot < handle
    %MOVEROBOT Summary of this class goes here
    %   Detailed explanation goes here

    properties
        %         EEx_;
        %         EEy_;
        %         EEz_;
    end

    methods
        function self = MoveRobot(nextEE)
            %MOVEROBOT Construct an instance of this class
            %   Detailed explanation goes here
            robot = IRB120(1,-0.6,1.05).model;
            %robot = IRB1206dof(1,-0.6,1.05).model;


            IRBEE = zeros(1,7);
            robot.fkine(IRBEE);
            currentEE = robot.fkine(IRBEE);

            EEx = currentEE(1,4);
            EEy = currentEE(2,4);
            EEz = currentEE(3,4);

            EEx2 = nextEE(1);
            EEy2 = nextEE(2);
            EEz2 = nextEE(3);

            disp("Current Position")
            disp(EEx)
            disp(EEy)
            disp(EEz)
            disp("Next Position")
            disp(EEx2)
            disp(EEy2)
            disp(EEz2)

            disp("Press Enter To Pick Up Coffee");
            pause;

            interpolation = 2;                                                         % 1 = Quintic Polynomial, 2 = Trapezoidal Velocity
            steps = 80;

            q0L = zeros(1,7);
            T1L = transl(EEx,EEy,EEz);                                                  % Create translation matrix
            %T1L = transl(0.8,0.3,0.6);
            q1L = robot.ikcon(T1L,q0L);                                                        % Derive joint angles for required end-effector transformation
            T2L = transl(EEx2,EEy2,EEz2);                                                   % Define a translation matrix
            q2L = robot.ikcon(T2L,q1L);
            %q2L = [0 1.005 1.850 -0.974 0 0 0];
            %checkEEPos = robot.fkine(q2L);

            disp("q1L")
            disp(q1L)
            disp("q2L")
            disp(q2L)
            pause;

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
                robot.plot(qMatrixL(i,:),'workspace', [-3 3 -3 3 -0.001 3], 'scale', 0.5, 'noarrow','fps', 120);
            end

            robot.fkine(qMatrixL(:,:,end))
        end


    end
end

