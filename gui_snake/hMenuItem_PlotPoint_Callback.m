function hMenuItem_PlotPoint_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hPlotObj = data_main.hPlotObj;

x0 = data_main.x0;
y0 = data_main.y0;
dx = data_main.dx;
dy = data_main.dy;

I = data_main.hPlotObj.snakeImage.CData;
x = data_main.Point.x;

for n = 1:data_main.nImages
    C = data_main.cont{n};

    % convert to xy
    C(:, 1) = (C(:, 1)-1)*dx+x0;
    C(:, 2) = (C(:, 2)-1)*dy+y0;

    xx = C(:, 2);
    yy = C(:, 1);

    [~, ind] = sort(abs(xx - x));
    px4 = xx(ind(1:4));
    py4 = yy(ind(1:4));

    [~, idx] = max(py4);
    ip = ind(idx);

    allP(n, :) = [x yy(ip)];
end

data_main.hAxis.PlotPoint.XLim = [1 data_main.nImages];

data_main.Point.AllPoint = allP;
hPlotObj.PlotPoint.All.XData = 1:data_main.nImages;
hPlotObj.PlotPoint.All.YData = allP(:,2);
hPlotObj.PlotPoint.All.MarkerSize = 16;
hPlotObj.PlotPoint.All.Color = 'c';

hPlotObj.PlotPoint.Current.XData = data_main.Point.iSlice;
hPlotObj.PlotPoint.Current.YData = allP(data_main.Point.iSlice, 2);
hPlotObj.PlotPoint.Current.MarkerSize = 24;

data_main.AllPointDone = true;
data_main.hSlider.snake.Visible = 'on';
data_main.hMenuItem.SavePoints.Enable = 'on';
data_main.hMenuItem.Tumor.Points.Enable = 'on';
data_main.hPushButton.DeleteSnake.Visible = 'on';
data_main.hMenuItem.DeletePoint.Checked = 'on';

updateTumorPoints(data_main);

data_main.hMenuItem.Tumor.Points.Checked = 'on';

%% initialize horizontal 2 lines on PointsPlot
% [x1 y1
%  x2 y2]
Lim(1,1) = 1;
Lim(2,1) = size(allP,1);
Lim(1,2) = min(allP(:, 2));
Lim(2,2) = max(allP(:, 2));

hA = data_main.hAxis.PlotPoint;

pos = Lim;
pos(1, 2) = pos(2, 2);
hUL = images.roi.Line(hA, 'InteractionsAllowed', 'translate', ...
    'Position', pos , 'Tag', 'UL');

pos = Lim;
pos(2, 2) = pos(1, 2);
hLL = images.roi.Line(hA, 'InteractionsAllowed', 'translate', ...
    'Color', 'g', 'Position', pos , 'Tag', 'LL');

addlistener(hUL, 'MovingROI', @hUL_callback);
addlistener(hLL, 'MovingROI', @hUL_callback);

data_main.LinePos.y1 = Lim(1, 2);
data_main.LinePos.y2 = Lim(2, 2);

%% save
guidata(hFig_main, data_main);                