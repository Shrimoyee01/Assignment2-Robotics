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

% DH Parameters for IRB120
l(1) = Link([0,     0.290, 0,    -pi/2]);
l(2) = Link([-pi/2, 0,     0.27, 0    ]);
l(3) = Link([0,     0,     0.07, -pi/2]);
l(4) = Link([0,     0.302, 0,    pi/2 ]);
l(5) = Link([0,     0,     0,    -pi/2]);
l(6) = Link([0,     0.072, 0,    0    ]);

I120 = SerialLink(l);

I120.plot([0,0,0,0,0,0]);



