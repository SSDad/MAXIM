function [] = fh_kpfcn(H, E)          

data_main = guidata(H);
hPlotObj = data_main.hPlotObj;

ixm = data_main.Point.ixm;
xi = data_main.Point.xi;
yi = data_main.Point.yi;
NP = data_main.Point.NP;

switch E.Key
    case 'rightarrow'
        ixm = ixm+1;
    case 'leftarrow'
        ixm = ixm-1;
%     case 'return'
%         hPlotObj.Point.Color = 'r';
%         set(H, 'keypressfcn', '');
    otherwise  
end

% on image
iSlice = round(data_main.hSlider.snake.Value);
hPlotObj.Point.XData = xi(ixm);
hPlotObj.Point.YData = yi(iSlice, ixm);

hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);

% on point plot
yy = mean(yi(:, ixm-NP:ixm+NP), 2);
hPlotObj.PlotPoint.All.YData = yy;
hPlotObj.PlotPoint.Current.XData = iSlice;
hPlotObj.PlotPoint.Current.YData = yy(iSlice);

xx = (1:data_main.nImages)';
data_main.Point.AllPoint = [xx yy];

% 2 line update
y1 = min(yy);
y2 = max(yy);
hPlotObj.UL.Position = [1 y2; data_main.nImages y2];
hPlotObj.LL.Position = [1 y1; data_main.nImages y1];
data_main.LinePos.y1 = y1;
data_main.LinePos.y2 = y2;

    hPlotObj.PlotPoint.Text.UL.Position(2) = y2;
    hPlotObj.PlotPoint.Text.UL.String =num2str(y2, '%4.1f');
    hPlotObj.PlotPoint.Text.LL.Position(2) = y1;
    hPlotObj.PlotPoint.Text.LL.String =num2str(y1, '%4.1f');
    hPlotObj.PlotPoint.Text.Gap.Position(2) = (y2+y1)/2;
    hPlotObj.PlotPoint.Text.Gap.String =num2str(y2-y1, '%4.1f');
    
    % tumor line
    hPlotObj.tumorUL.YData = [y2 y2];
    hPlotObj.tumorLL.YData = [y1 y1];
    
    strTP = num2str(length(yy));
    hPlotObj.Tumor.Text.UL.Position(2) = y2;
    hPlotObj.Tumor.Text.UL.String =['0 / ', strTP];
    hPlotObj.Tumor.Text.LL.Position(2) = y1;
    hPlotObj.Tumor.Text.LL.String = ['0 / ', strTP];
    hPlotObj.Tumor.Text.Gap.Position(2) = (y2+y1)/2;
    hPlotObj.Tumor.Text.Gap.String = [strTP, ' / ', strTP];

% update tumor points
data_main.Point.ixm = ixm;
data_main.hPlotObj = hPlotObj;
updateTumorPoints(data_main)

guidata(H, data_main);
