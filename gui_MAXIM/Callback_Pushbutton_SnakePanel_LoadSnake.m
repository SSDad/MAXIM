function Callback_Pushbutton_SnakePanel_LoadSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

ffn_snakes = data.FileInfo.ffn_snakes;

load(ffn_snakes);
data.Snake.Snakes = Snakes;
data.Snake.SlitherDone = true;

% show snake
x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;

iSlice = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
CB =   data.Snake.Snakes{iSlice};

if ~isempty(CB)
    hPlotObj = data.Panel.View.Comp.hPlotObj;
    hPlotObj.Snake.YData = (CB(:, 2)-1)*dy+y0;
    hPlotObj.Snake.XData = (CB(:, 1)-1)*dx+x0;
end

data.Panel.Snake.Comp.Pushbutton.FreeHand.Enable = 'off';
data.Panel.Snake.Comp.Togglebutton.ReDraw.Enable = 'on';
data.Panel.Snake.Comp.Pushbutton.Delete.Enable = 'on';
data.Panel.Snake.Comp.Pushbutton.SaveSnake.Enable = 'on';

data.Panel.Point.Comp.Popup.Neighbour.Enable = 'on';
data.Panel.Point.Comp.Pushbutton.Init.Enable = 'on';

% points
dataPath = data.FileInfo.DataPath;
matFile = data.FileInfo.MatFile;
[~, fn1, ~] = fileparts(matFile);
ffn_points = fullfile(dataPath, [fn1, '_Point.mat']);
if exist(ffn_points, 'file')
    load(ffn_points);
    data.Point.Data = Point;
    data.Point.InitDone = true;
    
    % show on snakei
    xi = data.Point.Data.xi;
    yi = data.Point.Data.yi;
    ixm = data.Point.Data.ixm;
    NP = data.Point.Data.NP;

    hPlotObj.Point.XData = xi(ixm);
    hPlotObj.Point.YData = yi(iSlice, ixm);
    hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
    hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
    hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
    hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
    
    data.Panel.Point.Comp.Popup.Neighbour.Enable = 'off';
    data.Panel.Point.Comp.Pushbutton.Init.Enable = 'off';
    data.Panel.Point.Comp.Togglebutton.Move.Enable = 'on';
    data.Panel.Point.Comp.Pushbutton.PointPlot.Enable = 'on';

end

guidata(hFig, data);