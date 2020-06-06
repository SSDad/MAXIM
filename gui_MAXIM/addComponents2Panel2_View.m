function Comp = addComponents2Panel2_View(hPanel)

Comp.hAxis.PlotPoint = axes('Parent',     hPanel, ...
                                'color',        'none',...
                                'xcolor', 'w',...
                                'ycolor', 'w', ...
                                'gridcolor',   'w',...
                                'Units',                    'normalized', ...
                                'HandleVisibility',     'callback', ...
                                'Position',                 [0.05 0.09 0.9 0.85]);

hA = Comp.hAxis.PlotPoint;
hA.YDir = 'reverse';
hold(hA, 'on')

% points
hPlotObj.PlotPoint.All = line(hA, 'XData', [], 'YData', [],  'Marker', '.',  'MarkerSize', 16, 'Color', 'c', 'LineStyle', '-');
hPlotObj.PlotPoint.Current = line(hA, 'XData', [], 'YData', [],  'Marker', '.',  'MarkerSize', 24, 'Color', 'r', 'LineStyle', 'none');

hPlotObj.Rect = images.roi.Rectangle(hA, 'Position',[0, 0, 0, 0], 'FaceAlpha', 0.2);
addlistener(hPlotObj.Rect, 'MovingROI', @Callback_Rect_PlotPoint);

FS = 10;
hPlotObj.Text.UL = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', FS);
hPlotObj.Text.LL = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', FS);
hPlotObj.Text.Gap = text(hA, 0, 0, '', 'Color', 'w', 'FontSize', FS);

hPlotObj.Text.UP = text(hA, 0, 0, '', 'Color', 'c', 'FontSize', FS);
hPlotObj.Text.LP = text(hA, 0, 0, '', 'Color', 'c', 'FontSize', FS);
hPlotObj.Text.MP = text(hA, 0, 0, '', 'Color', 'c', 'FontSize', FS);

Comp.hPlotObj = hPlotObj;