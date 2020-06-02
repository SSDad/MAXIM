 function Comp = addComponents2Panel_Point(hPanel)

 h_Gap = 0.025;
 h_Button = 0.15;
 w_Button = 0.7;
 x_Button = (1-w_Button)/2;
 
nG = 3;

w_Button2 = 0.45;
x_Button1 = 0.05;
x_Button2 = 0.5;

h = 1-h_Gap-h_Button;
Comp.Text.Neighbour = uicontrol('Parent', hPanel, ...
                                'Style', 'text', ...
                                'Units',                     'normalized', ...
                                'Position', [0.05 h 0.5 h_Button], ...
                                'FontSize', 14, ...
                                'BackgroundColor', 'k',...
                                'ForegroundColor', 'c',...
                                'Visible', 'on',...
                                'String', 'Neighbour Points');

Comp.Popup.Neighbour = uicontrol('Parent', hPanel, ...
                                'Style', 'popupmenu', ...
                                'Units',                     'normalized', ...
                                'Position', [0.6 h 0.3, h_Button], ...
                                'FontSize', 14, ...
                                'BackgroundColor', 'w',...
                                'ForegroundColor', 'b',...
                                'Visible', 'on',...
                                'String', {'0', '1', '2', '3', '4', '5', '6'});


h = h-h_Gap-h_Button;
Comp.Pushbutton.Init = uicontrol('parent', hPanel, ...
                                'Style', 'pushbutton',...
                                'String', 'Initialize Points',...
                                'Unit', 'Normalized',...
                                'Position', [x_Button h w_Button h_Button], ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Enable', 'on', ...
                                'Callback', @Callback_Pushbutton_PointPanel_Init);
                            

h = h-h_Gap-h_Button;
Comp.Togglebutton.Move = uicontrol('parent', hPanel, ...
                                'Style', 'Togglebutton',...
                                'String', 'Move Points',...
                                'Unit', 'Normalized',...
                                'Position', [x_Button h w_Button h_Button], ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Enable', 'on', ...
                                'Callback', @Callback_Togglebutton_PointPanel_Move);

h = h-h_Gap-h_Button;
Comp.Pushbutton.SavePoint = uicontrol('parent', hPanel, ...
                                'Style', 'pushbutton',...
                                'String', 'Save Points',...
                                'Unit', 'Normalized',...
                                'Position', [x_Button h w_Button h_Button], ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Enable', 'on', ...
                                'Callback', @Callback_Pushbutton_PointPanel_Save);
                            
h = h-h_Gap-h_Button;
Comp.Pushbutton.PointPlot = uicontrol('parent', hPanel, ...
                                'Style', 'pushbutton',...
                                'String', 'Point Plot',...
                                'Unit', 'Normalized',...
                                'Position', [x_Button1 h w_Button h_Button], ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Enable', 'on', ...
                                'Callback', @Callback_Pushbutton_PointPanel_PointPlot);
