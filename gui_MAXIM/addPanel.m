function Panel = addPanel(hFig)

w_Left = 0.2;
h_LoadImage = 0.2;
h_Snake = 0.4;
h_Point = 0.4;

w_Right = 0.05;

w_Middle = 1-w_Right-w_Left;
h_ContrastBar = 0.05;
h_View = 1-h_ContrastBar;

%% View
Panel.View.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [w_Left, 0, w_Middle, h_View], ...
                                'Title', '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'k',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');

%% Contrast bar
Panel.ContrastBar.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [w_Left, h_View, w_Middle, h_ContrastBar], ...
                                'Title', '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'k',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');

%% Slice slider
Panel.SliceSlider.hPanel = uipanel('Parent',                    hFig,...    
                                'Title',                        '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'Position',                  [w_Left+w_Middle, 0, w_Right, 1],...
                                    'visible',                      'on', ...
                                'ForegroundColor',       'w',...
                                'BackgroundColor',       'black', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'black');
%% Load image
Panel.LoadImage.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [0, h_Point+h_Snake, w_Left, h_LoadImage], ...
                                'Title', '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'k',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');



%% objective
Panel.Snake.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [0, h_Point, w_Left, h_Snake], ...
                                'Title', 'Snake',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'w',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');

%% structure
Panel.Point.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [0, 0., w_Left, h_Point], ...
                                'Title', 'Point',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'w',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');