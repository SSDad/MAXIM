 function Comp = addComponents2Panel_LoadImage(hPanel)

Comp.Pushbutton.LoadImage = uicontrol('parent', hPanel, ...
                                'Style', 'pushbutton',...
                                'String', 'Load  Images',...
                                'Unit', 'Normalized',...
                                'Position', [0.1 0.05 0.8 0.2], ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', [1 1 1]*0.25,...
                                'ForegroundColor', 'c',...
                                'Visible', 'on', ...
                                'Callback', @Callback_Pushbutton_LoadImagePanel_LoadImage);
                            
                            
% image info
Comp.hPanel.ImageInfo = uipanel('parent', hPanel,...
                                'Unit', 'Normalized',...
                                'Position', [.0, .35, 1, .65], ...
                                'Title', '',...
                                'FontSize',                 11,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'white',...
                                'BackgroundColor',       'black', ...
                                'HighlightColor',          'k',...
                                'ShadowColor',            'k');

nR = 3;
txt.FirstRow = {'Name', 'Value'};
txt.FirstColumn = {'FoV'; 'Image Size'; 'Pixel Size'};
columnRatio = [1]; % width ratio to first column
txt.DataStr = {'350'; ''; ''};

[Comp.hEdit.ImageInfo] = fun_myTable(Comp.hPanel.ImageInfo, nR, columnRatio, txt);
