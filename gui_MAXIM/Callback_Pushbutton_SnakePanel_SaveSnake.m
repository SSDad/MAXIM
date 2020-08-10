function Callback_Pushbutton_SnakePanel_SaveSnake(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

ffn_snakes = data.FileInfo.ffn_snakes;

Snakes = data.Snake.Snakes;
save(ffn_snakes, 'Snakes');

% save snake as csv
x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;

ffn_snakePoints = data.FileInfo.ffn_snakePoints;
ffn_snakePointsMatrix = data.FileInfo.ffn_snakePointsMatrix;
if exist(ffn_snakePoints, 'file')
    nSlice = length(Snakes);
    CP = [];  % Contour Points
    iSlice = 1;
    gC = Snakes{iSlice};
    if ~isempty(gC)
        gC(:, 1) = (gC(:, 1)-1)*dx+x0;
        gC(:, 2) = (gC(:, 2)-1)*dy+y0;
        nP = size(gC, 1);
        junk = [iSlice*ones(nP, 1) gC];
        CP = [CP; junk];
        xc = gC(:, 1);
    end

    for iSlice = 2:nSlice
        gC = Snakes{iSlice};
        if ~isempty(gC)
            gC(:, 1) = (gC(:, 1)-1)*dx+x0;
            gC(:, 2) = (gC(:, 2)-1)*dy+y0;
            nP = size(gC, 1);
            junk = [iSlice*ones(nP, 1) gC];
            CP = [CP; junk];
            
            xc = intersect(gC(:, 1), xc); % for matrix
        end
    end
    T = array2table(CP, 'VariableNames',{'Slice #', 'Xd', 'Yd'});
    writetable(T, ffn_snakePoints);

    % matrix
    CPM = [0 xc'];
    for iSlice = 1:nSlice
        gC = Snakes{iSlice};
        if ~isempty(gC)
            gC(:, 1) = (gC(:, 1)-1)*dx+x0;
            gC(:, 2) = (gC(:, 2)-1)*dy+y0;
            [~, ia, ib] = intersect(gC(:, 1), xc); % for matrix
            yc = gC(ia, 2)';
            CPM = [CPM; [iSlice yc]];
        end
    end
    T2 = array2table(CPM);
    writetable(T2, ffn_snakePointsMatrix, 'WriteVariableNames', 0);

end


if data.Point.InitDone
    Point = data.Point.Data;
    ffn_PointOnSnake = data.FileInfo.ffn_PointOnSnake;
    save(ffn_PointOnSnake, 'Point');
    msg = ['Snakes have been saved in ', ffn_snakes, ' and Points have been saved in ', ffn_PointOnSnake]; 
else
    msg = ['Snakes have been saved in ', ffn_snakes]; 
end
msgbox(msg);