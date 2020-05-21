function hMenuItem_Tumor_Points_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

%% 
if strcmp(data_main.hMenuItem.Tumor.Points.Checked, 'off')
    data_main.hMenuItem.Tumor.Points.Checked = 'on';
    updateTumorPoints(data_main);
    hPlotObj.Tumor.hgPoints.Visible = 'on';
else
    data_main.hMenuItem.Tumor.Points.Checked = 'off';
    hPlotObj.Tumor.hgPoints.Visible = 'off';
end
%% save
% guidata(hFig_main, data_main);                