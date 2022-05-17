%SIMULATIONGUI Robot passing coffee GUI
%
% GUI::
%
% - The specified callback function is invoked every time the joint configuration changes.
%   the joint coordinate vector.
% - The Quit (red X) button destroys the teach window.

function simulationGUI(MoveRobot)
    f = findobj(gca, 'Tag', MoveRobot.robot.model.name);
	if isempty(f)
		f = findobj(0, 'Tag', MoveRobot.robot.model.name);
		if isempty(f)
			MoveRobot.robot.model.plot(zeros(1, MoveRobot.robot.model.n));
			ax = gca;
		else
			ax = get(c(1), 'Parent');
		end
	else
	ax = gca;
	end
	
	bgcol = [000 100 000]/255;
	handles.fig = get(ax, 'Parent');
	set(ax, 'Outerposition', [0.25 0 0.7 1]);
	handles.curax = ax;
	
	%GUI panel
	panel = uipanel(handles.fig, ...
		'Title', 'ooeyGUI', ...
		'BackgroundColor', bgcol, ...
		'Position', [0.25 0, 0.15, 0.25]);
	set(panel, 'Units', 'pixels');
	handles.panel = panel;
	set(handles.fig, 'Units', 'pixels');
	set(handles.fig, 'ResizeFcn', @(src,event) resize_callback(MoveRobot.robot.model, handles));
	
	%% gui components
	%Exit button and callback
    uicontrol(panel, 'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [0.80 0.01 0.15 0.15], ...
        'FontUnits', 'normalized', ...
        'FontSize', 0.6, ...
        'CallBack', @(src,event) quit_callback(MoveRobot.robot.model, handles), ...
        'BackgroundColor', 'white', ...
        'ForegroundColor', 'red', ...
        'String', 'X');
	
	%Start button
	handles.start = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', 'Start', ...
		'Position', [0.12 0.4 0.3 0.3]);
	
	%Emergency stop button
	handles.emergencyStop = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', '<html>EMERGENCY<br />STOP</html>', ...
		'BackgroundColor', 'red', ...
		'FontSize', 9, ...
		'Position', [0.12 0.05 0.3 0.3]);
	
	%continue button
	handles.continue = uicontrol(panel, 'Style', 'pushbutton', ...
		'Units', 'normalized', ...
		'String', '<html>continue</html>', ...
		'Position', [0.47, 0.4, 0.3, 0.3]);
		
	%% Callbacks
	%darkness slider callback
	set(handles.start, ...
		'Interruptible', 'on', ...
		'Callback', @(src, event)start_callback(src, MoveRobot, handles));
	
	set(handles.emergencyStop, ...
		'Interruptible', 'off', ...
		'Callback', @(src, event)emergencyStop_callback(src, MoveRobot, handles));

	set(handles.continue, ...
		'Interruptible', 'off', ...
		'Callback', @(src, event)continue_callback(src, MoveRobot, handles));
	
end

%% Callback Functions
function start_callback(src, MoveRobot, handles)
	MoveRobot.stopState = 0;
	MoveRobot.runAnimation();
end

function emergencyStop_callback(src, MoveRobot, handles)
	MoveRobot.continueState = 0;
	MoveRobot.stopState = 1;
end

function continue_callback(src, MoveRobot, handles)
	MoveRobot.stopState = 0;
	MoveRobot.continueState = 1;
end
%callback to quit gui
function quit_callback(robot, handles)
    set(handles.fig, 'ResizeFcn', '');
    delete(handles.panel);
    set(handles.curax, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1])
end

%callback to resize
function resize_callback(handles)
   fig = gcbo;
   fs = get(fig, 'Position');
   ps = get(handles.panel, 'Position');
   set(handles.curax, 'Units', 'normalized', ...
	   'OuterPosition', [ps(3) 0 fs(3)-ps(3) fs(4)]);
   set(handles.panel, 'Position', [1 fs(4)-ps(4) ps(3:4)]);
end