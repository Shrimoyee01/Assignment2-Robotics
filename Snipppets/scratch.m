
clc
clf


% PlaceObject('R120Link1.ply',[transl(0,0,0)]);
camlight
% robot = IRB120test();
robot = IRB120(0,0,0);
robot.advancedTeach;

% robot = UR3();
% robot.model.teach

% L(1) = Link([0      0.29       0         pi/2   ]); 
% L(2) = Link([0      0         -0.27      0      ]);
% L(3) = Link([0      0         -0.07      pi/2   ]);
% L(4) = Link([0      0.302      0         pi/2   ]);
% L(5) = Link([0      0          0         pi/2   ]);
% L(6) = Link([0      0.072      0          0     ]);
% 
% 
% % Incorporate joint limits
% L(1).qlim = [-2*pi 2*pi];
% L(2).qlim = [-2*pi 2*pi];
% L(3).qlim = [-2*pi 2*pi];
% L(4).qlim = [-2*pi 2*pi];
% L(5).qlim = [-2*pi 2*pi];
% L(6).qlim = [-2*pi 2*pi];
% 
% 
% L(1).offset =  -pi;
% L(2).offset =  -pi/2;
% L(4).offset =  pi;
% L(5).offset =  pi;
% 
% 
% robot = SerialLink(L, 'name', 'robot'); 
% 
% workspace = [-1 1 -1 1 -0 1];                                       % Set the size of the workspace when drawing the robot
% 
% scale = 0.5;
% 
% q = zeros(1,6);                                                     % Create a vector of initial joint angles
% 
% robot.plot(q,'workspace',workspace,'scale',scale); 