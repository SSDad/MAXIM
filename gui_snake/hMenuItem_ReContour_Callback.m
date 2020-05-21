function hMenuItem_ReContour_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
tb = data_main.hToggleButton.Manual;
menu = data_main.hMenuItem.ReContour;

if strcmp(menu.Checked, 'off')
    tb.Visible = 'on';
    menu.Checked = 'on';
else
    tb.Visible = 'off';
    menu.Checked = 'off';
end