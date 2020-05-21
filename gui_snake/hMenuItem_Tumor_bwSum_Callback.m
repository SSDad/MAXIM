function hMenuItem_Tumor_bwSum_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

if strcmp(data_main.hMenuItem.Tumor.bwSum.Checked, 'off')
    data_main.hMenuItem.Tumor.bwSum.Checked = 'on';
    updateTumorOverlay(data_main);
    hPlotObj.Tumor.bwSum.Visible = 'on';
else
    data_main.hMenuItem.Tumor.bwSum.Checked = 'off';
    hPlotObj.Tumor.bwSum.Visible = 'off';
end