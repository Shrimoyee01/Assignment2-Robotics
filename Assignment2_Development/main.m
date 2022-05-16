%% Main code
clf
clear all
clc

%% Environment Setup
clf
clear all
clc

Enviro();

nextEE = [0.7,-1.05,1.03];
IRB120(1,-0.6,1.05).model;

%MoveRobot(nextEE)

%% Animation run
animation = Animation();

pause(5);
axis([-3 3 -3 3 0 2.7]);
view(50,30);


%%
clf
clear all
clc

robot = IRB120(0,0,0).model;

interpolation = 2;                                                         % 1 = Quintic Polynomial, 2 = Trapezoidal Velocity
steps = 80;

q0L = zeros(1,7);
T1L = transl(-0.5,0,0.6);                                                  % Create translation matrix
q1L = robot.ikcon(T1L,q0L);                                                        % Derive joint angles for required end-effector transformation
T2L = transl(0.5,0.5,0.5);                                                   % Define a translation matrix
q2L = robot.ikcon(T2L,q1L);

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
    robot.plot(qMatrixL(i,:),'workspace', [-2 2 -2 2 0 2], 'scale', 0.15, 'noarrow','fps', 120);
end

robot.fkine(qMatrixL(:,:,end))

%%
clf
clear all
clc

robot = IRB120(0.5,-0.7,1.1).model;

IRBEE = zeros(1,7);
currentEE = robot.fkine(IRBEE)
EEx = currentEE(1,4)
EEy = currentEE(2,4)
EEz = currentEE(3,4)

%%
clf
clear all
clc
robot = IRB120(0.5,0.3,1.1).model;