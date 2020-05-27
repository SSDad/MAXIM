function Callback_Pushbutton_SnakePanel_LoadSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

ffn_snakes = data.FileInfo.ffn_snakes;
fi = dir(ffn_snakes);
fdate = fi.date;

msg = ['There are saved snakes dated ' fdate, ', would you like to load them?']; 

answer = questdlg(msg, 'Saved Snakes', 'Yes', 'No', 'Yes');
% Handle response
switch answer
    case 'Yes'
        load(ffn_snakes);
        data.Snake.Snakes = Snakes;
        data.Snake.SlitherDone = true;

        % show snake
        x0 = data.Image.x0;
        y0 = data.Image.y0;
        dx = data.Image.dx;
        dy = data.Image.dy;
        
        sV = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
        CB =   data.Snake.Snakes{sV};
        data.Panel.View.Comp.hPlotObj.Snake.YData = (CB(:, 2)-1)*dy+y0;
        data.Panel.View.Comp.hPlotObj.Snake.XData = (CB(:, 1)-1)*dx+x0;

%         data.hMenuItem.FreeHand.Enable = 'off';
%         data.hMenuItem.ReContour.Enable = 'on';

    case 'No'
        return
end

guidata(hFig, data);