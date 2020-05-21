function hPushButton_DeleteSnake_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hPlotObj = data_main.hPlotObj;
hAxis = data_main.hAxis;

iSlice = round(data_main.hSlider.snake.Value);
data_main.cont{iSlice} = [];
data_main.Point.xi(iSlice) = nan;
data_main.Point.yi(iSlice, :) = nan;
data_main.Point.AllPoint(iSlice, :) = [nan nan];

% remove data from image contours
hPlotObj.cont.XData = [];
hPlotObj.cont.YData = [];

% remove points from image
hPlotObj.Point.XData = [];
hPlotObj.Point.YData = [];

% remove point from points plot
% hPlotObj.PlotPoint.All.XData = data_main.Point.AllPoint(:, 2);
hPlotObj.PlotPoint.All.YData = data_main.Point.AllPoint(:, 2);

hPlotObj.PlotPoint.Current.XData = [];
hPlotObj.PlotPoint.Current.YData = [];
hPlotObj.LeftPoints.XData = [];
hPlotObj.LeftPoints.YData = [];
hPlotObj.RightPoints.XData = [];
hPlotObj.RightPoints.YData = [];

% remove data from track contours
data_main.Tumor.mask_GC(:, :, iSlice) = false;
data_main.Tumor.mask_TC(:, :, iSlice) = false;
data_main.Tumor.CC_GC{iSlice} = [];
data_main.Tumor.CC_TC{iSlice} = [];

bwSum = sum(data_main.Tumor.mask_GC, 3)+sum(data_main.Tumor.mask_TC, 3);
hPlotObj.Tumor.bwSum.CData = bwSum;
if any(bwSum(:))
    hAxis.Tumor.CLim = [min(bwSum(:)) max(bwSum(:))];
end

hPlotObj.Tumor.TrackContour(iSlice).XData = [];
hPlotObj.Tumor.TrackContour(iSlice).YData = [];
hPlotObj.Tumor.GatedContour(iSlice).XData = [];
hPlotObj.Tumor.GatedContour(iSlice).YData = [];

% save data
data_main.hPlotObj = hPlotObj;
guidata(hFig_main, data_main);