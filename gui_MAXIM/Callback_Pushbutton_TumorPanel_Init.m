function Callback_Pushbutton_TumorPanel_Init(src, evnt)

global hFig hFig2

data = guidata(hFig);
data2 = guidata(hFig2);

hAxis = data2.Panel.Tumor.Comp.hAxis;                         

% tumor contour with 1x1 pixel size
[mask_GC, mask_TC, CC_GC, CC_TC, CC_RC] = getTumorContour(hFig);

% binary image
bwSum = sum(mask_GC, 3)+sum(mask_TC, 3);
data2.Panel.Tumor.Comp.hPlotObj.Tumor.bwSum = imshow(bwSum, data.Image.RA, 'parent',  hAxis.Tumor);
if any(bwSum(:))
      hAxis.Tumor.CLim = [min(bwSum(:)) max(bwSum(:))];
end
% linkaxes([hAxis.snake hAxis.Tumor]);

data.Tumor.mask_GC = mask_GC;
data.Tumor.mask_TC = mask_TC;
data.Tumor.CC_GC = CC_GC;
data.Tumor.CC_TC = CC_TC;
data.Tumor.RC_TC = CC_RC;

% contour
hPlotObj = data2.Panel.Tumor.Comp.hPlotObj;
hPlotObj.Tumor.hgTrackContour = hggroup(hAxis.Tumor);
hPlotObj.Tumor.hgGatedContour = hggroup(hAxis.Tumor);
hPlotObj.Tumor.hgPoints = hggroup(hAxis.Tumor);
xmin = inf;
xmax = 0;
ymin = inf;
ymax = 0;
for n = 1:data.Image.nImages
    hPlotObj.Tumor.TrackContour(n) = line(hPlotObj.Tumor.hgTrackContour, ...
        'XData',  [], 'YData',  [],  'Color', 'b', 'LineStyle', '-', 'LineWidth', 1);
    if ~isempty(CC_TC{n})
        hPlotObj.Tumor.TrackContour(n).XData = CC_TC{n}(:, 1);
        xmin = min(min(CC_TC{n}(:, 1)), xmin);
        xmax = max(max(CC_TC{n}(:, 1)), xmax);

        hPlotObj.Tumor.TrackContour(n).YData = CC_TC{n}(:, 2);
        ymin = min(min(CC_TC{n}(:, 2)), ymin);
        ymax = max(max(CC_TC{n}(:, 2)), ymax);
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

% profile
marg = 0.2;
xL = xmax-xmin;
yM = (ymin+ymax)/2;
pos = [xmin-xL*marg  yM
          xmax+xL*marg yM];
      
hPlotObj.Tumor.ProfileLine = images.roi.Line(hAxis.Tumor, 'Color', 'c', 'Position', pos , 'Tag', 'PL');
addlistener(hPlotObj.Tumor.ProfileLine, 'MovingROI', @Callback_Line_Profile);

data2.Panel.Tumor.Comp.hPlotObj = hPlotObj;
guidata(hFig2, data2);
guidata(hFig, data);

updateTumorProfile;

% points
if data.Point.InitDone
    xi = data.Point.Data.xi;
    ixm = data.Point.Data.ixm;
    yy = data.Point.Data.yy;
%     for n = 1:size(yi,1)
%         yy = yi(n,:);
%         junk = ~isnan(yy);
%         xmin = min(xi(find(junk, 1, 'first')), xmin);
%         xmax = max(xi(find(junk, 1, 'last')), xmax);
%     end
    junk = min(yy);   ymin = min(junk, ymin);
    junk = max(yy);    ymax = max(junk, ymax);
    xmin = min(xmin, xi(ixm));
    xmax = max(xmax, xi(ixm));
    
    hPlotObj.Tumor.hgPoints = hggroup(hAxis.Tumor);
    for n = 1:data.Image.nImages
        hPlotObj.Tumor.Points(n) = line(hPlotObj.Tumor.hgPoints, 'XData', [], 'YData', [],...
            'Marker', '.',  'MarkerSize', 12, 'Color', 'c', 'LineStyle', 'none');
    end
    
    data2.Panel.Tumor.Comp.hPlotObj = hPlotObj;
    guidata(hFig2, data2);
    updateTumorPoint;
end

dx = xmax-xmin;
dy = ymax-ymin;
mg = 0.2;
xmin = xmin-dx*mg;
xmax = xmax+dx*mg;
ymin = ymin-dy*mg;
ymax = ymax+dy*mg;

hAxis.Tumor.XLim = [xmin xmax];
hAxis.Tumor.YLim = [ymin ymax];

data.Tumor.xmin = xmin;
data.Tumor.xmax = xmax;
data.Tumor.ymin = ymin;
data.Tumor.ymax = ymax;
data.Tumor.InitDone = true;

data.Panel.Point.Comp.Pushbutton.PointPlot.Enable = 'on';

guidata(hFig, data);

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

data2.Panel.Button.Comp.Radiobutton.Profile.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.Profile.Value = 1;
data2.Panel.Button.Comp.Radiobutton.bwSum.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.bwSum.Value = 1;
data2.Panel.Button.Comp.Radiobutton.Contour.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.Contour.Value = 1;
data2.Panel.Button.Comp.Radiobutton.Point.Enable = 'on';
data2.Panel.Button.Comp.Radiobutton.Point.Value = 1;
data2.Panel.Tumor.Comp.hPlotObj = hPlotObj;
guidata(hFig2, data2);

hFig2.Visible = 'on';