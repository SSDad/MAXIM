function Callback_Togglebutton_BodyPanel_Boundary(src, evnt)

global hFig
global bondaryLimits 

data = guidata(hFig);

str = src.String;

if strcmp(str, 'Boundary Lines')
    src.String = 'Done';
    src.ForegroundColor = 'r';
%     src.BackgroundColor = [1 1 1]*0.25;
else
    src.String = 'Boundary Lines';
    src.ForegroundColor = 'g';
end