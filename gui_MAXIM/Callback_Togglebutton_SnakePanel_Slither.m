function Callback_Togglebutton_SnakePanel_Slither(src, evnt)

global stopSlither

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

bV = src.Value;
% iSlice = round(data_main.hSlider.snake.Value);

if bV
    src.String = 'Stop';
    src.ForegroundColor = 'r';
    src.BackgroundColor = [1 1 1]*0.25;
    
x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;

L = data.Snake.FreeHand.L;
II = data.Image.Images;

sV = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
J = rot90(rgb2gray(II{sV}), 3);
[mJ, nJ] = size(J);
cAF = L.Position;

% convert to ij
cAF(:, 1) = (cAF(:, 1)-data.Image.x0)/data.Image.dx+1;
cAF(:, 2) = (cAF(:, 2)-data.Image.y0)/data.Image.dy+1;

% snakes
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

T = J(y1:y2, x1:x2);

%% template match
hPlotObj = data.Panel.View.Comp.hPlotObj;
mMid = round(mJ/2);
for n = 1:nImages
    
    if stopSlither
        src.String = 'Slither';
        src.ForegroundColor = 'g';
        stopSlither = false;
        src.Value = 0;
        break;
    end
    
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

    % snake on cropped
    Rect = [xoffSet+1, yoffSet+1, size(T,2), nJ-yoffSet];
    [sC] = fun_findDiaphragm(J, Rect, C);

    data.Snake.Snakes{n} = sC;
   
    % show
    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = n;
    hPlotObj.Image.CData = rot90(data.Image.Images{n}, 3);
    hPlotObj.Snake.YData = (sC(:, 2)-1)*dy+y0;
    hPlotObj.Snake.XData = (sC(:, 1)-1)*dx+x0;
    data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(n), ' / ', num2str(nImages)];
    drawnow;

    clear sC;
    
end
    data.Snake.SlitherDone = true;

    % enable buttons
    data.Panel.Snake.Comp.Togglebutton.ReDraw.Enable = 'on';
    data.Panel.Snake.Comp.Pushbutton.Delete.Enable = 'on';
    data.Panel.Snake.Comp.Pushbutton.SaveSnake.Enable = 'on';

    data.Panel.Point.Comp.Popup.Neighbour.Enable = 'on';
    data.Panel.Point.Comp.Pushbutton.Init.Enable = 'on';

    guidata(hFig, data);

    src.String = 'Slither';
    src.ForegroundColor = 'g';
    src.Value = 0;
else
    stopSlither = true;
end