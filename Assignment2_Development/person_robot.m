function Assignment1()
close;
clear;
clc;
clf;

axis on;
% axis ([-5 5 -5 5 -1.5 4]);
axis auto

view(3);
hold on;


doCameraSpin = false;
Axis_Control.Clipping = "off";
set(gca,'CameraViewAngleMode','Manual');

% Person1Loc = [-0.5,-1,0.4];
%
% PlaceObject('person1.ply',[Person1Loc(1),Person1Loc(2),Person1Loc(3)]);




% % Create a person
% % Person();
% % Person().PlotSingleRandomStep
% %
% %  Plot the transform of the UAV starting at the origin (same as exercise 1)
% % uavTR{1} = eye(4);
% % trplot(uavTR{1})
% %
% % for personIndex = 1:Person().cowCount
% %     display(['At trajectoryStep ',num2str(personIndex),' the UAV TR to person ',num2str(personIndex),' is ']);
% %     display(num2str(inv(uavTR{1}) * Person().cow{personIndex}.base));
% % end
% % Person().PlotSingleRandomStep();
% % end

%% EDIT THIS!!
clf;
clear all;
try delete(peopleHerd); end;

    function Person()
        [f,v,data] = plyread('person1.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255; %% Scale the colours to be 0-to-1 (they are originally 0 to 255)
        
        trisurf(f,v(:,1),v(:,2) , v(:,3) ... % Then plot the trisurf with offset verticies
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
    end
peopleHerd = Person(2);
peopleHerd.PlotSingleRandomStep();
numSteps=1;
delay=0.1;
for x=1:1:100
    peopleHerd.TestPlotManyStep(numSteps,delay);
    %     vecsize = size(cowHerd.cow{1}.base);
    %%cow1
    people1x = peopleHerd.people{1}.base(1,4);
    people1y = peopleHerd.people{1}.base(2,4);
    %%people 2
    people2x = peopleHerd.people{2}.base(1,4);
    people2y = peopleHerd.people{2}.base(2,4);
    tr1 = transl(people1x,people1y,5); %% Translates z axis + 10
    trplot(tr1);
    tr2 = transl(people2x,people2y,5); %% Translates z axis + 10
    trplot(tr2);
end
end
