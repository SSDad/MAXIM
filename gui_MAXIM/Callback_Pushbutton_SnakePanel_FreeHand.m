function Callback_Pushbutton_SnakePanel_FreeHand(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

hSlider = data.Panel.SliceSlider.Comp.hSlider.Slice;
data.FreeHand.iSlice = round(hSlider.Value);

hA = data.Panel.View.Comp.hAxis.Image;
uistack(hA, 'top');

axis(hA);
L = images.roi.AssistedFreehand(hA,...
    'Image', data.Panel.View.Comp.hPlotObj.Image, ...
    'Closed', 0);
% L = images.roi.AssistedFreehand('Image', data.Panel.View.Comp.hPlotObj.Image, ...
%     'Closed', 0);
draw(L);

data.FreeHand.L = L;
data.FreeHand.Done = true;

data.Panel.Snake.Comp.Panel.FreeHand.Togglebutton.Slither.Enable = 'on';

%% save
guidata(hFig, data);                