function Callback_Togglebutton_BodyPanel_Boundary(src, evnt)

global hFig
global AbBoundLim 

data = guidata(hFig);
hRect = data.Panel.View.Comp.hPlotObj.AbRect;

str = src.String;

if strcmp(str, 'Boundary Lines')
    src.String = 'Done';
    src.ForegroundColor = 'r';
    hRect.Color = 'Green';
    hRect.Visible = 'on';
%     src.BackgroundColor = [1 1 1]*0.25;
else
    src.String = 'Boundary Lines';
    src.ForegroundColor = 'g';
    hRect.Color = 'Red';
    AbBoundLim = [hRect.Position(2) hRect.Position(2)+hRect.Position(4)];
end