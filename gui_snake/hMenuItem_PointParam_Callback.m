function hMenuItem_PointParam_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if strcmp(data_main.hMenuItem.PointParam.Checked, 'on')
    data_main.hMenuItem.PointParam.Checked = 'off';
    data_main.hText.Neighbour.Visible = 'off';
    data_main.hPopup.Neighbour.Visible = 'off';
else
    data_main.hMenuItem.PointParam.Checked = 'on';
    data_main.hText.Neighbour.Visible = 'on';
    data_main.hPopup.Neighbour.Visible = 'on';
end

%% save
guidata(hFig_main, data_main);                