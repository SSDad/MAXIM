function updateTrackContour(data_main)

hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

% hPlotObj.Tumor.hgTrackContour.Visible = 'on';
% hPlotObj.Tumor.hgGatedContour.Visible = 'on';

indSS = data_main.Tumor.indSS;

for n = 1:data_main.nImages
    hPlotObj.Tumor.GatedContour(n).Visible = 'off';
    hPlotObj.Tumor.TrackContour(n).Visible = 'off';
end

CC_GC = data_main.Tumor.CC_GC;
CC_TC = data_main.Tumor.CC_TC;
for iSS = 1:length(indSS)
    n = indSS(iSS);
    if ~isempty(CC_GC{n})
        hPlotObj.Tumor.GatedContour(n).Visible = 'on';
    end
    if ~isempty(CC_TC{n})
        hPlotObj.Tumor.TrackContour(n).Visible = 'on';
    end
end
