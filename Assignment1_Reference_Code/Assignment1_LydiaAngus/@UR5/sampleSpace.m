function sampleSpace(self)

%% sampleSpace
%measures the end effector location at each joint angle to find the
%vertical and horzontal workspace

%measuring horizonatly by rotating around the base joint fully extended
q = zeros(6, 1);
q(2, 1) = pi/2; %set the model reaching out
counter = 1;
sampleLineH = zeros(360, 3);
for q1 = 0:pi/180:2*pi %iterate through 1 degree steps for 360 degrees
    q(1) = q1;
    effT = self.model.fkine(q);
    sampleLineH(counter, :) = effT(1:3, 4)';
    counter = counter + 1;
end
hold on
plot3(sampleLineH(:,1),sampleLineH(:,2),sampleLineH(:,3),'r.');
hold off

%measuring vertically by rotating around the base joint fully extended
q = zeros(6, 1);
counter = 1;
sampleLineV = zeros(360, 3);
for q2 = -pi/2:pi/180:pi/2
    q(2) = q2;
    effT = self.model.fkine(q);
    sampleLineV(counter, :) = effT(1:3, 4)';
    counter = counter + 1;
end
hold on
plot3(sampleLineV(:,1),sampleLineV(:,2),sampleLineV(:,3),'r.');
hold off

% robotCentre = transl(self.model.base);

%calculating the reach distance by finding the max and min along a plane
%and then halfing the distance to find the radius for the reach
reachDistanceX = (max(sampleLineH(:,1))-min(sampleLineH(:,1)))/2;
reachDistanceZ = max(sampleLineV(:,3))-min(sampleLineV(:,3));
workspaceRadius = reachDistanceX;
disp1 = ['UR5 workspace radius is ', num2str(workspaceRadius), 'm'];
disp(disp1);

% Volume V=4/3*πr^3
% caulating the spherical volume and then divided by 2 due to table
workspaceVolume = (4/3*pi*reachDistanceX^3)/2;
disp2 = ['UR5 workspace volume is ', num2str(workspaceVolume), 'm3'];
disp(disp2);




end

