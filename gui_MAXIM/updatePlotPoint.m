function updatePlotPoint

global hFig hFig2

data = guidata(hFig);
Point = data.Point;

xi = Point.Data.xi;
yi = Point.Data.yi;
ixm = Point.Data.ixm;
NP = Point.Data.NP;
iSlice = Point.Data.iSlice;

xx = (1:size(yi, 1))';
yy = mean(yi(:, ixm-NP:ixm+NP), 2);

data2 = guidata(hFig2);

hPlotObj = data2.Panel.View.Comp.hPlotObj;

hPlotObj.PlotPoint.All.XData = xx;
hPlotObj.PlotPoint.All.YData = yy;

hPlotObj.PlotPoint.Current.XData =xx(iSlice);
hPlotObj.PlotPoint.Current.YData = yy(iSlice);

x0 = 0;
y0 = min(yy);
w = length(xx);
h = range(yy);
hPlotObj.Rect.Position = [x0 y0 w, h];

y1 = max(yy);
n0 = 0;
n1 = 0;

updatePlotPointRectText(hPlotObj.Text, y0, y1, w, n0, n1)

data.Point.xx = xx;
data.Point.yy = yy;
guidata(hFig, data)


% % [x1 y1
% %  x2 y2]
% Lim(1,1) = 1;
% Lim(2,1) = size(allP,1);
% Lim(1,2) = min(allP(:, 2));
% Lim(2,2) = max(allP(:, 2));
% 
% posUL = Lim;
% posUL(1, 2) = posUL(2, 2);
% posLL = Lim;
% posLL(2, 2) = posLL(1, 2);
% 
%     hPlotObj.UL.Position = posUL;
%     hPlotObj.LL.Position = posLL;

% line position text
%     hPlotObj.Text.UL.Position(1) = length(xx)+3;
%     hPlotObj.Text.UL.Position(2) = posUL(2,2);
%     hPlotObj.Text.UL.String = num2str(posUL(2,2), '%4.1f');
%     
%     hPlotObj.Text.LL.Position(1) = length(xx)+3;
%     hPlotObj.Text.LL.Position(2) = posLL(2,2);
%     hPlotObj.Text.LL.String = num2str(posLL(2,2), '%4.1f');
%     
%     hPlotObj.Text.Gap.Position(1) = length(xx)+3;
%     hPlotObj.Text.Gap.Position(2) = (posUL(2,2)+posLL(2,2))/2;
%     hPlotObj.Text.Gap.String = num2str(posUL(2,2)-posLL(2,2), '%4.1f');

% data_main.LinePos.y1 = Lim(1, 2);
% data_main.LinePos.y2 = Lim(2, 2);
% 
% data_main.LinePos.x = posLL(:, 1);
