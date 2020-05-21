function hMenuItem_Tumor_TrackContour_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;
hSlider = data_main.hSlider;

%% 
if strcmp(data_main.hMenuItem.Tumor.TrackContour.Checked, 'off')
    data_main.hMenuItem.Tumor.TrackContour.Checked = 'on';
    updateTrackContour(data_main);
    hPlotObj.Tumor.hgTrackContour.Visible = 'on';
    hPlotObj.Tumor.hgGatedContour.Visible = 'on';
else
    data_main.hMenuItem.Tumor.TrackContour.Checked = 'off';
    hPlotObj.Tumor.hgTrackContour.Visible = 'off';
    hPlotObj.Tumor.hgGatedContour.Visible = 'off';
end    