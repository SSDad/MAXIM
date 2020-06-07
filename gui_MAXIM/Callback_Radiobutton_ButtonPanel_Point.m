function Callback_Radiobutton_ButtonPanel_Point(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);
hAxis = data.Panel.Tumor.Comp.hAxis.Tumor;
hPlotObj = data.Panel.Tumor.Comp.hPlotObj;

if data.Panel.Button.Comp.Radiobutton.Point.Value
    hPlotObj.Tumor.hgPoints.Visible = 'on';
else
    hPlotObj.Tumor.hgPoints.Visible = 'off';
end