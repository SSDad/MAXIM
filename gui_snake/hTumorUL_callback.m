function hTumorUL_callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    hPlotObj = data_main.hPlotObj;
    
    allP = data_main.Point.AllPoint;
    if strcmp(src.Tag, 'tumorUL')
        y1 = data_main.tumorLinePos.y1;
        y2 = src.Position(1,2);
        data_main.tumorLinePos.y2 = y2;
    else
        y2 = data_main.tumorLinePos.y2;
        y1 = src.Position(1,2);
        data_main.tumorLinePos.y1 = y1;
    end
        
    hPlotObj.Tumor.Text.UL.Position(2) = y2;
    hPlotObj.Tumor.Text.UL.String =num2str(y2, '%4.1f');
    hPlotObj.Tumor.Text.LL.Position(2) = y1;
    hPlotObj.Tumor.Text.LL.String =num2str(y1, '%4.1f');
    hPlotObj.Tumor.Text.Gap.Position(2) = (y2+y1)/2;
    hPlotObj.Tumor.Text.Gap.String =num2str(y2-y1, '%4.1f');
    
    hPlotObj.UL.Position(:,2) = hPlotObj.tumorUL.Position(:,2);
    guidata(hFig_main, data_main);
    
%     if y2>y1
%         data_main.Tumor.indSS = find(allP(:, 2) >= y1 & allP(:, 2) <= y2);
%         guidata(hFig_main, data_main);
% 
% %         if strcmp(data_main.hMenuItem.Tumor.bwSum.Checked, 'on')
%             updateTumorOverlay(data_main);
% %         end
%         
%         if strcmp(data_main.hMenuItem.Tumor.TrackContour.Checked, 'on')
%             updateTrackContour(data_main);
%         end
%         
% %         if strcmp(data_main.hMenuItem.Tumor.Points.Checked, 'on')
%             updateTumorPoints(data_main);
% %         end
%         
%         if strcmp(data_main.hMenuItem.Tumor.Profile.Checked, 'on')
%             updateTumorProfile(data_main);
%         end
%     end
    