function hUL_callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    hPlotObj = data_main.hPlotObj;
    
    allP = data_main.Point.AllPoint;
    if strcmp(src.Tag, 'UL')
        y1 = data_main.LinePos.y1;
        y2 = src.Position(1,2);
        data_main.LinePos.y2 = y2;
    else
        y2 = data_main.LinePos.y2;
        y1 = src.Position(1,2);
        data_main.LinePos.y1 = y1;
    end
    
    % point line
    hPlotObj.UL.Position(:, 1) = data_main.LinePos.x;
    hPlotObj.LL.Position(:, 1) = data_main.LinePos.x;
    
    hPlotObj.PlotPoint.Text.UL.Position(2) = y2;
    hPlotObj.PlotPoint.Text.UL.String =num2str(y2, '%4.1f');
    hPlotObj.PlotPoint.Text.LL.Position(2) = y1;
    hPlotObj.PlotPoint.Text.LL.String =num2str(y1, '%4.1f');
    hPlotObj.PlotPoint.Text.Gap.Position(2) = (y2+y1)/2;
    hPlotObj.PlotPoint.Text.Gap.String =num2str(y2-y1, '%4.1f');
    
    % tumor line
    hPlotObj.tumorUL.YData = [y2 y2];
    hPlotObj.tumorLL.YData = [y1 y1];
    
TP = size(allP, 1)-sum(isnan(allP(:, 2)));
UP = sum(allP(:,2)>y2);
LP = sum(allP(:,2)<y1);
strTP = num2str(TP);
strUP = num2str(UP);
strLP = num2str(LP);
strGP = num2str(TP-UP-LP);
    hPlotObj.Tumor.Text.UL.Position(2) = y2;
    hPlotObj.Tumor.Text.UL.String =[strUP, ' / ', strTP];
    hPlotObj.Tumor.Text.LL.Position(2) = y1;
    hPlotObj.Tumor.Text.LL.String = [strLP, ' / ', strTP];
    hPlotObj.Tumor.Text.Gap.Position(2) = (y2+y1)/2;
    hPlotObj.Tumor.Text.Gap.String = [strGP, ' / ', strTP];

    if y2>y1
        data_main.Tumor.indSS = find(allP(:, 2) >= y1 & allP(:, 2) <= y2);
        guidata(hFig_main, data_main);

%         if strcmp(data_main.hMenuItem.Tumor.bwSum.Checked, 'on')
            updateTumorOverlay(data_main);
%         end
        
        if strcmp(data_main.hMenuItem.Tumor.TrackContour.Checked, 'on')
            updateTrackContour(data_main);
        end
        
%         if strcmp(data_main.hMenuItem.Tumor.Points.Checked, 'on')
%             updateTumorPoints(data_main);
%         end
        
        if strcmp(data_main.hMenuItem.Tumor.Profile.Checked, 'on')
            updateTumorProfile(data_main);
        end
    end
    