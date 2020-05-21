function hMenuItem_Slither_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
pnSlither = data_main.hPanel.Slither;
pnSGolayParam = data_main.hPanel.SGolayParam;
pnSnakeParam = data_main.hPanel.SnakeParam;

menu = data_main.hMenuItem.Slither;

if strcmp(menu.Checked, 'off')
    pnSlither.Visible = 'on';
    pnSGolayParam.Visible = 'on';
    pnSnakeParam.Visible = 'on';
    menu.Checked = 'on';
else
    pnSlither.Visible = 'off';
    pnSGolayParam.Visible = 'off';
    pnSnakeParam.Visible = 'off';
    menu.Checked = 'off';
end