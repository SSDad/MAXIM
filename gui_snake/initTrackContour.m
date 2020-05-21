function initTrackContour(hFig_main)

data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

hPlotObj.Tumor.hgTrackContour.Visible = 'on';
hPlotObj.Tumor.hgGatedContour.Visible = 'on';

CC_GC = data_main.Tumor.CC_GC;
CC_TC = data_main.Tumor.CC_TC;

% Contour plot
for n = 1:data_main.nImages
    if ~isempty(CC_GC{n})
        hPlotObj.Tumor.GatedContour(n).XData = CC_GC{n}(:, 2);
        hPlotObj.Tumor.GatedContour(n).YData = CC_GC{n}(:, 1);
    end
    if ~isempty(CC_TC{n})
        hPlotObj.Tumor.TrackContour(n).XData = CC_TC{n}(:, 2);
        hPlotObj.Tumor.TrackContour(n).YData = CC_TC{n}(:, 1);
    end
end

data_main.hMenuItem.Tumor.TrackContour.Checked = 'on';
