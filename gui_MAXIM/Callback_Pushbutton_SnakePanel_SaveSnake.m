function Callback_Pushbutton_SnakePanel_SaveSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

ffn_snakes = data.FileInfo.ffn_snakes;

Snakes = data.Snake.Snakes;
save(ffn_snakes, 'Snakes');

if data.Point.InitDone
    Point = data.Point;
    ffn_points = data.FileInfo.ffn_points;
    save(ffn_points, 'Point');
    msg = ['Snakes have been saved in ', ffn_snakes, ' and Points have been saved in ', ffn_points]; 
else
    msg = ['Snakes have been saved in ', ffn_snakes]; 
end
msgbox(msg);