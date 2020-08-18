function Callback_Radiobutton_SelectionPanel_(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

if strcmp(src.Tag, 'Body')
    hRB = data.Panel.Selection.Comp.Radiobutton.Diaphragm;
else
    hRB = data.Panel.Selection.Comp.Radiobutton.Body;
end

if src.Value
    hRB.Value = 0;
else
    hRB.Value = 1;
end

if data.Panel.Selection.Comp.Radiobutton.Diaphragm.Value
    data.Panel.Body.hPanel.Visible = 'off';
    data.Panel.Snake.hPanel.Visible = 'on';
    data.Panel.Point.hPanel.Visible = 'on';
else
    data.Panel.Snake.hPanel.Visible = 'off';
    data.Panel.Point.hPanel.Visible = 'off';
    data.Panel.Body.hPanel.Visible = 'on';
end