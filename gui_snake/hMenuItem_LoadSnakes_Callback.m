function hMenuItem_LoadSnakes_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

ffn_snakes = data_main.ffn_snakes;
fi = dir(ffn_snakes);
fdate = fi.date;

msg = ['There are saved snakes dated ' fdate, ', would you like to load them?']; 

answer = questdlg(msg, 'Saved Snakes', 'Yes', 'No', 'Yes');
% Handle response
switch answer
    case 'Yes'
        load(ffn_snakes);
        data_main.cont = snakes;
        data_main.SnakeDone = true;

        % show snake
        x0 = data_main.x0;
        y0 = data_main.y0;
        dx = data_main.dx;
        dy = data_main.dy;
        
        sV = round(data_main.hSlider.snake.Value);
        CB =   data_main.cont{sV};
        data_main.hPlotObj.cont.YData = (CB(:, 2)-1)*dy+y0;
        data_main.hPlotObj.cont.XData = (CB(:, 1)-1)*dx+x0;

        data_main.hMenuItem.FreeHand.Enable = 'off';
        data_main.hMenuItem.ReContour.Enable = 'on';

    case 'No'
        return
end

guidata(hFig_main, data_main);