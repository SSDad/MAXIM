function hMenuItem_DeletePoint_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
pb = data_main.hPushButton.DeleteSnake;
menu = data_main.hMenuItem.DeletePoint;

if strcmp(menu.Checked, 'off')
    pb.Visible = 'on';
    menu.Checked = 'on';
else
    pb.Visible = 'off';
    menu.Checked = 'off';
end