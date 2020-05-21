function Comp = addComponents2Panel_View(hPanel)

global contrastRectLim

% axes
Comp.hAxis.Image = axes('Parent',                   hPanel, ...
                            'color',        'none',...
                            'xcolor', 'w',...
                            'ycolor', 'w', ...
                            'gridcolor',   'w',...
                            'Units',                    'normalized', ...
                            'HandleVisibility',     'callback', ...
                            'Position',                 [0.05 0.025 0.9 0.9]);

Comp.hAxis.Image.XAxisLocation='top';
hold(Comp.hAxis.Image, 'on')

% imshow
Comp.hPlotObj.Image = imshow([], 'parent', Comp.hAxis.Image);

% slider
Comp.hSlider.Slice = uicontrol('Parent',  hPanel,...
            'Style','slider',...
            'units', 'normalized',...
            'Position',[.95 0.05 0.03 0.7],...
            'BackgroundColor', 'b',...
            'ForegroundColor', 'w',...
            'Visible', 'on', ...
                'Callback', @Callback_Slider_ViewPanel_Slice);
            
Comp.hText.nImages = uicontrol('Parent', hPanel, ...
                                'Style', 'text', ...
                                'Units',                     'normalized', ...
                                'Position', [0.85 0.01 0.14 0.03], ...
                                'FontSize', 12, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', 'b',...
                                'ForegroundColor', 'w',...
                                'Visible', 'on', ...
                                'String', 'iSlice / nSlices');

% contrast bar
Comp.Panel.Contrast.hPanel = uipanel('parent', hPanel,...
                                'Unit', 'Normalized',...
                                'Position', [.25, .94, .5, .05], ...
                                'Title', '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'k',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'k',...
                                'ShadowColor',            'k');

Comp.Panel.Constrast.hAxis = axes('Parent',        Comp.Panel.Contrast.hPanel , ...
                    'color',        [1 1 1]*0.25,...
                    'Units',       'normalized', ...
                    'Position',    [0. 0. 1. 1.]);
hold(Comp.Panel.Constrast.hAxis, 'on');

Comp.Panel.Constrast.hPlotObj.Hist = line(Comp.Panel.Constrast.hAxis,...
    'XData', [], 'YData', [], 'Color', 'w', 'LineStyle', '-', 'LineWidth', 1);
Comp.Panel.Constrat.hPlotObj.Rect = images.roi.Rectangle(Comp.Panel.Constrast.hAxis,...
    'Position',[0, 0,1, 1], 'FaceAlpha', 0.3);
addlistener(Comp.Panel.Constrat.hPlotObj.Rect, 'MovingROI', @Callback_ContrastRect);

Comp.Panel.Constrast.hAxis = [0 1];
Comp.Panel.Constrast.hAxis = [0 1];

contrastRectLim = [0 1];