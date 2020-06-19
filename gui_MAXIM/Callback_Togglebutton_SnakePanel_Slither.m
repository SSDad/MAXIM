function Callback_Togglebutton_SnakePanel_Slither(src, evnt)

global stopSlither 

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

startSlice = str2double(data.Panel.Snake.Comp.Edit.StartSlice.String);
endSlice = str2double(data.Panel.Snake.Comp.Edit.EndSlice.String);

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
for iSlice = startSlice:endSlice
    
    if stopSlither
        break;
    end
    
    if data.Tumor.bInd_GC(iSlice) | data.Tumor.bInd_TC(iSlice) % gating or tracking contour on image
    
        J =  rgb2gray(II{iSlice});
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
    
    else
        sC = [];
    end    

    data.Snake.Snakes{iSlice} = sC;
   
    % snake on gui
    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
    hPlotObj.Image.CData = rot90(data.Image.Images{iSlice}, 3);
    if isempty(sC)
        hPlotObj.Snake.YData = [];
        hPlotObj.Snake.XData = [];
    else
        hPlotObj.Snake.YData = (sC(:, 2)-1)*dy+y0;
        hPlotObj.Snake.XData = (sC(:, 1)-1)*dx+x0;
    end
    data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(nImages)];
    
    % points
    if data.Point.InitDone && ~isempty(sC)
        xi = data.Point.Data.xi;
        ixm = data.Point.Data.ixm;
        NP = data.Point.Data.NP;
        yi = data.Point.Data.yi;

        [~, yi(iSlice, :)] = fun_PointOnCurve(sC, dx, dy, x0, y0, xi, yi(iSlice, :));
        data.Point.Data.yi = yi;

        hPlotObj = data.Panel.View.Comp.hPlotObj;
        hPlotObj.Point.XData = xi(ixm);
        hPlotObj.Point.YData = yi(iSlice, ixm);
        hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
        hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
        hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
        hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
    
        guidata(hFig, data)
        updatePlotPoint;
    end
    
    drawnow;
    clear sC;

end

    if stopSlither
        src.String = 'Slither';
        src.ForegroundColor = 'g';
        stopSlither = false;
        src.Value = 0;
        
        hPlotObj.Snake.XData = [];
        hPlotObj.Snake.YData = [];
        
    else
        data.Snake.SlitherDone = true;

        % enable buttons
        data.Panel.Snake.Comp.Togglebutton.ReDraw.Enable = 'on';
        data.Panel.Snake.Comp.Pushbutton.Delete.Enable = 'on';
        data.Panel.Snake.Comp.Pushbutton.SaveSnake.Enable = 'on';

        data.Panel.Point.Comp.Popup.Neighbour.Enable = 'on';
        data.Panel.Point.Comp.Pushbutton.Init.Enable = 'on';
    end

    guidata(hFig, data);

    src.String = 'Slither';
    src.ForegroundColor = 'g';
    src.Value = 0;
else
    stopSlither = true;
end