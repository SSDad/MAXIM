function Callback_Pushbutton_SnakePanel_DeleteSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

sV = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
data.Snake.Snakes{sV} = [];
data.Panel.View.Comp.hPlotObj.Snake.YData = [];
data.Panel.View.Comp.hPlotObj.Snake.XData = [];

guidata(hFig, data)