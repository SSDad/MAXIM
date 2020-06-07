function Callback_Pushbutton_TumorPanel_Init(src, evnt)

global hFig hFig2

data = guidata(hFig);
data2 = guidata(hFig2);

% data2.Panel.Tumor.hAxis.Tumor = axes('Parent',                   data2.Panel.Tumor.hPanel, ...
%                             'color',        'none',...
%                             'xcolor', 'w',...
%                             'ycolor', 'w', ...
%                             'gridcolor',   'w',...
%                             'Units',                    'normalized', ...
%                             'HandleVisibility',     'callback', ...
%                             'Position',                 [0.05 0.025 0.9 0.9]);
% 
% hAxis = data2.Panel.Tumor.hAxis;                         
% hAxis.Tumor.XAxisLocation='top';
% hold(hAxis.Tumor, 'on')

hAxis = data2.Panel.Tumor.Comp.hAxis;                         

% tumor contour with 1x1 pixel size
[mask_GC, mask_TC, CC_GC, CC_TC, CC_RC] = getTumorContour(hFig);

% binary image
bwSum = sum(mask_GC, 3)+sum(mask_TC, 3);
data2.Panel.Tumor.Comp.hPlotObj.Tumor.bwSum = imshow(bwSum, data.Image.RA, 'parent',  hAxis.Tumor);
if any(bwSum(:))
     data2.Panel.Tumor.hAxis.Tumor.CLim = [min(bwSum(:)) max(bwSum(:))];
end
% linkaxes([hAxis.snake hAxis.Tumor]);

data.Tumor.mask_GC = mask_GC;
data.Tumor.mask_TC = mask_TC;
data.Tumor.CC_GC = CC_GC;
data.Tumor.CC_TC = CC_TC;
data.Tumor.RC_TC = CC_RC;

% data.hMenuItem.Tumor.bwSum.Checked = 'on';

% contour
hPlotObj = data2.Panel.Tumor.Comp.hPlotObj;
hPlotObj.Tumor.hgTrackContour = hggroup(hAxis.Tumor);
hPlotObj.Tumor.hgGatedContour = hggroup(hAxis.Tumor);
hPlotObj.Tumor.hgPoints = hggroup(hAxis.Tumor);
x0 = inf;
x1 = 0;
y0 = inf;
y1 = 0;
for n = 1:data.Image.nImages
    hPlotObj.Tumor.TrackContour(n) = line(hPlotObj.Tumor.hgTrackContour, ...
        'XData',  [], 'YData',  [],  'Color', 'b', 'LineStyle', '-', 'LineWidth', 1);
    if ~isempty(CC_TC{n})
        hPlotObj.Tumor.TrackContour(n).XData = CC_TC{n}(:, 1);
        x0 = min(min(CC_TC{n}(:, 1)), x0);
        x1 = max(max(CC_TC{n}(:, 1)), x1);

        hPlotObj.Tumor.TrackContour(n).YData = CC_TC{n}(:, 2);
        y0 = min(min(CC_TC{n}(:, 2)), y0);
        y1 = max(max(CC_TC{n}(:, 2)), y1);
    end
    
    hPlotObj.Tumor.GatedContour(n) = line(hPlotObj.Tumor.hgGatedContour, ...
        'XData', [], 'YData', [],  'Color', 'g', 'LineStyle', '-', 'LineWidth', 1);
    if ~isempty(CC_GC{n})
        hPlotObj.Tumor.GatedContour(n).XData = CC_GC{n}(:, 1);
        hPlotObj.Tumor.GatedContour(n).YData = CC_GC{n}(:, 2);
    end
    
    hPlotObj.Tumor.Points(n) = line(hPlotObj.Tumor.hgPoints, 'XData', [], 'YData', [],...
        'Marker', '.',  'MarkerSize', 12, 'Color', 'c', 'LineStyle', 'none');
end

n = 1;
hPlotObj.Tumor.RefContour(n) = line(hAxis.Tumor, ...
    'XData', [], 'YData', [],  'Color', 'r', 'LineStyle', '-', 'LineWidth', 1);
if ~isempty(CC_RC{n})
    hPlotObj.Tumor.RefContour(n).XData = CC_RC{n}(:, 1);
    hPlotObj.Tumor.RefContour(n).YData = CC_RC{n}(:, 2);
end

dx = x1-x0;
dy = y1-y0;
mg = 0.2;
xmin = x0-dx*mg;
xmax = x1+dx*mg;
ymin = y0-dy*mg;
ymax = y1+dy*mg;

hAxis.Tumor.XLim = [xmin xmax];
hAxis.Tumor.YLim = [ymin ymax];

data.Tumor.xmin = xmin;
data.Tumor.xmax = xmax;
data.Tumor.ymin = ymin;
data.Tumor.ymax = ymax;
guidata(hFig, data);

%
% 
% for n = 1:data_main.nImages
%     if ~isempty(CC_GC{n})
%         hPlotObj.Tumor.GatedContour(n).XData = CC_GC{n}(:, 2);
%         hPlotObj.Tumor.GatedContour(n).YData = CC_GC{n}(:, 1);
%     end
%     if ~isempty(CC_TC{n})
%         hPlotObj.Tumor.TrackContour(n).XData = CC_TC{n}(:, 2);
%         hPlotObj.Tumor.TrackContour(n).YData = CC_TC{n}(:, 1);
%     end
% end

% data.hMenuItem.Tumor.TrackContour.Checked = 'on';

% % turn on
% hPlotObj.Tumor.bwSum.Visible = 'on';

%% save data
% data.hAxis = hAxis;

data2.Panel.Button.Comp.Radiobutton.Profile.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.bwSum.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.bwSum.Value = 1;
data2.Panel.Button.Comp.Radiobutton.Contour.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.Contour.Value = 1;
data2.Panel.Button.Comp.Radiobutton.Point.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.Point.Value = 1;
data2.Panel.Tumor.Comp.hPlotObj = hPlotObj;
guidata(hFig2, data2);