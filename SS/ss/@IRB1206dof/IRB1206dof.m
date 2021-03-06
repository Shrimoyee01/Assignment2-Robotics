%%UR3 Class
classdef IRB1206dof < handle
    properties
        %> Robot model
        model;

        %>
        workspace = [-3 3 -3 3 -0.01 2.5];

        %> Flag to indicate if gripper is used
        useGripper = false;

        %> robotic base location
        %base;

        %> robotic base location
        maxWorkspace;
        
        %>
        xPos;
        yPos;
        zPos;
        zYaw;

        
        qlim;

    end

    methods%% Class for UR5 robot simulation
        function self = IRB1206dof(xPosition, yPosition, zPosition)

            %> Catch function for if a base is supplied wwith less than 1 input.
%             if nargin < 1
%                 base = transl(0, 0, 0);
%             end

            %self.base = base;

            %> Position for base of robot
            self.xPos = xPosition;
            self.yPos = yPosition;
            self.zPos = zPosition;
            %self.zYaw = (zYawAmount/360*pi*2);

            % robot =
            self.GetIRB120Robot();

            % robot =
            self.PlotAndColourRobot();

            % Workspace
%             self.sampleSpace();
            
        end

        %% GetUR3Robot
        % Given a name (optional), create and return a UR3 robot model
        function GetIRB1206dofRobot(self)
            %     if nargin < 1
            % Create a unique name (ms timestamp after 1ms pause)
            pause(0.001);
            name = ['IRB120_',datestr(now,'yyyymmddTHHMMSSFFF')];
            %     end

            % Create the IRB 120 model
            %limits found online
            %joint angle theta between the x, link offset d along the z, link length a along the x, link twist
            %alpha rotating the joint
            % DH Parameters for IRB120
            %file:///C:/Users/aesti/Downloads/1035-Article%20Text-1000-1-10-20211218.pdf

%             l(1) = Link(['d',290,'a',0,   'alpha',pi/2, 'theta', -pi]);
%             l(2) = Link(['d',0,  'a',-270,'alpha',0,    'theta', -pi/2]);
%             l(3) = Link(['d',0,  'a',-70, 'alpha',pi/2, 'theta', 0]);
%             l(4) = Link(['d',302,'a',0,   'alpha',pi/2, 'theta', pi]);
%             l(5) = Link(['d',0,  'a',0,   'alpha',pi/2, 'theta', pi]);
%             l(6) = Link(['d',72, 'a',0,   'alpha',0,    'theta', 0]);

            % theta=q, d=0, a=0, alpha=0, offset=0
            L(1) = Link([0      0.29       0         pi/2   0]); 
            L(2) = Link([0      0         -0.27      0      0]);
            L(3) = Link([0      0         -0.07      pi/2   0]);
            L(4) = Link([0      0.302      0         pi/2   0]);
            L(5) = Link([0      0          0         pi/2   0]);
            L(6) = Link([0      0.072      0          0     0]);


            % Incorporate joint limits
            L(1).qlim = [-180 180]*pi/180;
            L(2).qlim = [-110 110]*pi/180;
            L(3).qlim = [-110 70]*pi/180;
            L(4).qlim = [-160 160]*pi/180;
            L(5).qlim = [-120 120]*pi/180;
            L(6).qlim = [-400 400]*pi/180;


            L(1).offset =  -pi;
            L(2).offset =  -pi/2;
            L(4).offset =  pi;
            L(5).offset =  pi;

            
            %self.model = SerialLink(L,'name',name, 'base', self.base ); 
            self.model = SerialLink(L,'name','IRB');

            self.model.base = self.model.base * transl(self.xPos,self.yPos,self.zPos);
            self.model.base = self.model.base * trotz(pi);

%             self.model.base = transl(0,0,0)*trotz(pi);

        end
        %% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available
        function PlotAndColourRobot(self) %robot,workspace)
            for linkIndex = 0:self.model.n
                if self.useGripper && linkIndex == self.model.n
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['R120Link',num2str(linkIndex),'Gripper.ply'],'tri'); %#ok<AGROW>
                else
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['R120Link',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                end
                self.model.faces{linkIndex+1} = faceData;
                self.model.points{linkIndex+1} = vertexData;
            end

            % Display robot
            self.model.plot3d(zeros(1,self.model.n),'noarrow','workspace',self.workspace);
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end
            self.model.delay = 0;

            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.model.n
                handles = findobj('Tag', self.model.name);
                h = get(handles,'UserData');
                try
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                        , plyData{linkIndex+1}.vertex.green ...
                        , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
    end
end