 function Comp = addComponents2Panel_About(hPanel)

 Comp.Pushbutton.About = uicontrol('parent', hPanel, ...
                                'Style', 'pushbutton',...
                                'String', 'MAXIM',...
                                'Unit', 'Normalized',...
                                'Position', [0.25 0.25 0.5 0.5], ...
                                'FontSize', 10, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Enable', 'on', ...
                                'Callback', @Callback_Pushbutton_About);