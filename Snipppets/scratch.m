
clc
clf


camlight
% robot = IRB120test();

robot = IRB120(0,0,0);
robot.advancedTeach;

location1 = transl(1,0,0);

cup1 = Thing("cup4",location1);

disp("press enter to continue");
pause;

cup1.updatePosition(transl(0,1,0.5));

