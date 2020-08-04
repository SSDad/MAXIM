function Callback_Pushbutton_SnakePanel_SaveSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

ffn_snakes = data.FileInfo.ffn_snakes;

Snakes = data.Snake.Snakes;
save(ffn_snakes, 'Snakes');

% save snake as csv
ffn_snakePoints = data.FileInfo.ffn_snakePoints;
if ~exist(ffn_snakePoints, 'file')
    nSlice = length(Snakes);
    CPM = [];
    for iSlice = 1:nSlice
        gC = Snakes{iSlice};
        if ~isempty(gC)
            nP = size(gC, 1);
            junk = [iSlice*ones(nP, 1) gC];
            CPM = [CPM; junk];
        end
    end
    T = array2table(CPM, 'VariableNames',{'Slice #', 'Xd', 'Yd'});
    writetable(T, ffn_snakePoints);

end


if data.Point.InitDone
    Point = data.Point.Data;
    ffn_points = data.FileInfo.ffn_points;
    save(ffn_points, 'Point');
    msg = ['Snakes have been saved in ', ffn_snakes, ' and Points have been saved in ', ffn_points]; 
else
    msg = ['Snakes have been saved in ', ffn_snakes]; 
end
msgbox(msg);