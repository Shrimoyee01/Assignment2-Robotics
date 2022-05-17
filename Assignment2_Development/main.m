%% Main code
clf
clear all
clc
Animation.qMatrix
%% Environment Setup
clf
clear all
clc

CafeEnvironment();

nextEE = [1,-1.05,1.03+0.28];
%IRB120(1,-0.6,1.05).model;

MoveRobot(nextEE)
%LinearUR5(false,0.7,-1.05,1.03,90)
% nextEE = [0.5,0,1.2];
% MoveRobot(nextEE)

%% Animation run
animation = Animation();

pause(5);
axis([-3 3 -3 3 0 2.7]);
view(50,30);

%%
clf
clear all
clc

robot = IRB120(0,0,0);
robot.advancedTeach;

location1 = transl(1,0,0);

cup1 = Thing("cup4",location1);

disp("press enter to continue");
pause;

cup1.updatePosition(transl(0,1,0.5));

%%
clf
clear all
clc

%CafeEnvironment();
IRB120(1,-0.6,1.05).model;

%%
robot = IRB120(0,0,0);
robot.advancedTeach;

location1 = transl(1,0,0);

cup1 = Thing("cup4",location1);

disp("press enter to continue");
pause;

cup1.updatePosition(transl(0,1,0.5));


%%
clf
clear all
clc
CafeEnvironment();
Test();

