function hPushButton_TMSnake_Start_Callback(src, evnt)

global stopSlither

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hPlotObj = data_main.hPlotObj;
x0 = data_main.x0;
y0 = data_main.y0;
dx = data_main.dx;
dy = data_main.dy;

L = data_main.FreeHand.L;
II = data_main.Images;

sV = round(data_main.hSlider.snake.Value);
J = rot90(rgb2gray(II{sV}), 3);
[mJ, nJ] = size(J);
cAF = L.Position;

% convert to ij
cAF(:, 1) = (cAF(:, 1)-data_main.x0)/data_main.dx+1;
cAF(:, 2) = (cAF(:, 2)-data_main.y0)/data_main.dy+1;

%% snakes
% hWB = waitbar(0, 'Snake slithering...');
nImages = length(II);

L.Visible = 'off';

xMarg = 10;
yMarg = 10;
    
%% rect
xmin = round(min(cAF(:, 1)));
xmax = round(max(cAF(:, 1)));
ymin = round(min(cAF(:, 2)));
ymax = round(max(cAF(:, 2)));

y1 = ymin-yMarg;
y2 = ymax-yMarg;
x1 = xmin-xMarg;
x2 = xmax+xMarg;

% hRect = rectangle(hA(1), 'Position', [x1 y1 x2-x1 y2-y1], 'EdgeColor', 'g');
T = J(y1:y2, x1:x2);

%% template match

mMid = round(mJ/2);
for n = 1:nImages
    J =  rgb2gray(II{n});
    J = rot90(J, 3);

    J2 = J(mMid:end, :);

% template match
nXC = normxcorr2(T, J2);
[ypeak, xpeak] = find(nXC==max(nXC(:)));
yoffSet = ypeak-size(T,1);
yoffSet = yoffSet+mMid;
xoffSet = xpeak-size(T,2);

C(:, 1) = cAF(:, 1)+xoffSet-x1;
C(:, 2) = cAF(:, 2)+yoffSet-y1;


% hF(n) = figure(n);  clf(hF(n));
% hA(n) = axes('parent', hF(n));
% hJ(n) = imshow(J, [], 'parent', hA(n));
% rectangle(hA(n), 'Position',...
%     [xoffSet+1, yoffSet+1, size(T,2), size(T,1)],...
%     'EdgeColor', 'c');
% 
% hC(n) = line(hA(n), 'XData', C(:, 1), 'YData', C(:, 2), 'Color', 'c');

% snake on cropped
Rect = [xoffSet+1, yoffSet+1, size(T,2), nJ-yoffSet];
[sC] = fun_findDiaphragm(J, Rect, C);
% hsC(n) = line(hA(n), 'XData', sC(:, 1), 'YData', sC(:, 2),...
%     'Color', 'm', 'LineWidth', 2);


data_main.cont{n} = sC;

   
    % show
    data_main.hSlider.snake.Value = n;
    hPlotObj.snakeImage.CData = rot90(data_main.Images{n}, 3);
hPlotObj.cont.YData = (sC(:, 2)-1)*dy+y0;
hPlotObj.cont.XData = (sC(:, 1)-1)*dx+x0;
    data_main.hText.nImages.String = [num2str(n), ' / ', num2str(data_main.nImages)];
    drawnow;

    clear sC;
    
    if stopSlither
        stopSlither = false;
        break;
    end
end
% close(hWB);

data_main.SnakeDone = true;


% data_main.hToggleButton.Manual.Visible = 'on';
data_main.hMenuItem.SaveSnakes.Enable = 'on';
% data_main.hMenuItem.ReContour.Enable = 'on';
% data_main.hMenuItem.ReContour.Checked = 'on';
% visboundaries(data_main.hAxis.snake, bw, 'Color', 'r'); 




%% save
guidata(hFig_main, data_main);                