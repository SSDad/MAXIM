function hMenuItem_FreeHand_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hSlider = data_main.hSlider.snake;

data_main.FreeHand.iSlice = round(hSlider.Value);

% axis(data_main.hAxis.snake);
L = images.roi.AssistedFreehand(data_main.hAxis.snake,...
    'Image', data_main.hPlotObj.snakeImage, ...
    'Closed', 0);
draw(L);

data_main.FreeHand.L = L;
data_main.FreeHandDone = true;

data_main.hMenuItem.snake.Enable = 'on';

%% save
guidata(hFig_main, data_main);                