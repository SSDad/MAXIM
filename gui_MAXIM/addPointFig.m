function View = addPointFig(hFig)
            
View.hPanel = uipanel('parent', hFig,...
                                'Unit', 'Normalized',...
                                'Position', [0., 0., 1, 1], ...
                                'Title', '',...
                                'FontSize',                 12,...
                                'Units',                     'normalized', ...
                                'visible',                      'on', ...
                                'ForegroundColor',       'k',...
                                'BackgroundColor',       'k', ...
                                'HighlightColor',          'c',...
                                'ShadowColor',            'k');
                            
View.hAxis.PlotPoint = axes('Parent',     View.hPanel, ...
                                'color',        'none',...
                                'xcolor', 'w',...
                                'ycolor', 'w', ...
                                'gridcolor',   'w',...
                                'Units',                    'normalized', ...
                                'HandleVisibility',     'callback', ...
                                'Position',                 [0.05 0.09 0.9 0.85]);

hA = View.hAxis.PlotPoint;
hA.YDir = 'reverse';
hold(hA, 'on')

% points
hPlotObj.PlotPoint.All = line(hA, 'XData', [], 'YData', [],  'Marker', '.',  'MarkerSize', 16, 'Color', 'c', 'LineStyle', '-');
hPlotObj.PlotPoint.Current = line(hA, 'XData', [], 'YData', [],  'Marker', '.',  'MarkerSize', 24, 'Color', 'r', 'LineStyle', 'none');

% 2 lines
% posUL = zeros(2,2);
% posLL = posUL;
% hPlotObj.UL = images.roi.Line(hA, 'InteractionsAllowed', 'translate', ...
%         'Position', posUL, 'Tag', 'UL');
% 
% hPlotObj.LL = images.roi.Line(hA, 'InteractionsAllowed', 'translate', ...
%         'Color', 'g', 'Position', posLL, 'Tag', 'LL');
% 
% addlistener(hPlotObj.UL, 'MovingROI', @hUL_callback);
% addlistener(hPlotObj.LL, 'MovingROI', @hUL_callback);

hPlotObj.Rect = images.roi.Rectangle(hA, 'Position',[0, 0, 0, 0], 'FaceAlpha', 0.2);
addlistener(hPlotObj.Rect, 'MovingROI', @Callback_Rect_PointPlot);

hPlotObj.Text.UL = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', 12);
hPlotObj.Text.LL = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', 12);
hPlotObj.Text.Gap = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', 12);

View.hPlotObj = hPlotObj;