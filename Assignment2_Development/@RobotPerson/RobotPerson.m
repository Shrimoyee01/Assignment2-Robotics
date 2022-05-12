classdef RobotPerson < handle
    %ROBOTCOWS A way of creating a herd of robot cows
    %   The cows can be moved around randomly. It is then possible to query
    %   the current location (base) of the cows.
    
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 10;
    end
    
    properties
        %> Number of people
        peopleCount = 2;
        
        %> A cell structure of \c cowCount cow models
        people;
        
        %> paddockSize in meters
        paddockSize = [10,10];
        
        %> Dimensions of the workspace in regard to the padoc size
        workspaceDimensions;
    end
    
    methods
        %% ...structors
        function self = RobotPeople(peopleCount)
            if 0 < nargin
                self.peopleCount = peopleCount;
            end
            
            self.workspaceDimensions = [-self.paddockSize(1)/2, self.paddockSize(1)/2 ...
                ,-self.paddockSize(2)/2, self.paddockSize(2)/2 ...
                ,0,self.maxHeight];
            
            % Create the required number of cows
            for i = 1:self.peopleCount
                self.people{i} = self.GetPeopleModel(['people',num2str(i)]);
                % Random spawn
                self.cow{i}.base = se3(se2((2 * rand()-1) * self.paddockSize(1)/2 ...
                    , (2 * rand()-1) * self.paddockSize(2)/2 ...
                    , (2 * rand()-1) * 2 * pi));
                % Plot 3D model
                plot3d(self.people{i},0,'workspace',self.workspaceDimensions,'view',[-30,30],'delay',0);
                % Hold on after the first plot (if already on there's no difference)
                if i == 1
                    hold on;
                end
            end
            
            axis equal
            camlight;
        end
        
        function delete(self)
            %             cla;
        end
        
        %% PlotSingleRandomStep
        % Move each of the cows forward and rotate some rotate value around
        % the z axis
        function PlotSingleRandomStep(self)
            for peopleIndex = 1:self.peopleCount
                % Move Forward
                self.people{peopleIndex}.base = self.people{peopleIndex}.base * se3(se2(0.2, 0, 0));
                animate(self.people{peopleIndex},0);
                % Turn randomly
                self.people{peopleIndex}.base(1:3,1:3) = self.people{peopleIndex}.base(1:3,1:3) *  rotz((rand-0.5) * 30 * pi/180);
                animate(self.people{peopleIndex},0);
                
                % If outside workspace rotate back around
                if self.people{peopleIndex}.base(1,4) < self.workspaceDimensions(1) ...
                        || self.workspaceDimensions(2) < self.people{peopleIndex}.base(1,4) ...
                        || self.people{peopleIndex}.base(2,4) < self.workspaceDimensions(3) ...
                        || self.workspaceDimensions(4) < self.people{peopleIndex}.base(2,4)
                    self.people{peopleIndex}.base = self.people{peopleIndex}.base * se3(se2(-0.2, 0, 0)) * se3(se2(0, 0, pi));
                end
            end
            % Do the drawing once for each interation for speed
            drawnow();
        end
        
        %% TestPlotManyStep
        % Go through and plot many random walk steps
        function TestPlotManyStep(self,numSteps,delay)
            if nargin < 3
                delay = 0;
                if nargin < 2
                    numSteps = 200;
                end
            end
            for i = 1:numSteps
                self.PlotSingleRandomStep();
                pause(delay);
            end
        end
    end
    
    methods (Static)
        %% GetpeopleModel
        function model = GetPeopleModel(name)
            if nargin < 1
                name = 'People';
            end
            [faceData,vertexData] = plyread('person1.ply','tri');
            L1 = Link('alpha',-pi/2,'a',0,'d',0.3,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2) + 0.4;
            model.points = {vertexData * rotx(-pi/2),[]};
        end
    end
end

