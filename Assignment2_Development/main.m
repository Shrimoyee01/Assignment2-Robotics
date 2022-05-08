%% Main code
clf
clear all
clc

%% Environment Setup
clf
clear all
clc

Enviro();
LinearUR5(false,0.5,-0.2,1.03,270).model;

%% Animation run
animation = Animation();

pause(5);
axis([-3 3 -3 3 0 2.7]);
view(50,30);

%% Load Robot
IRB120



