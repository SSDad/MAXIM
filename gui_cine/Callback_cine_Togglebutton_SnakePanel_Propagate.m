function Callback_cine_Togglebutton_SnakePanel_Propagate(src, evnt)

bPlot = 0;

global fhSlice
global stopSlither


hFig_cine = ancestor(src, 'Figure');
data_cine = guidata(hFig_cine);

% startSlice = str2double(data_cine.Panel.Snake.Comp.Edit.StartSlice.String);
% endSlice = str2double(data_cine.Panel.Snake.Comp.Edit.EndSlice.String);

bV = src.Value;
% iSlice = round(data_main.hSlider.snake.Value);

if bV
    src.String = 'Stop';
    src.ForegroundColor = 'r';
    src.BackgroundColor = [1 1 1]*0.25;
    
    x0 = data_cine.Image.x0;
    y0 = data_cine.Image.y0;
    dx = data_cine.Image.dx;
    dy = data_cine.Image.dy;

% L = data_cine.Snake.FreeHand.L;
    II = data_cine.Image.Images;
    nSlices = length(II);

    startSlice = fhSlice;
    endSlice = nSlices;
    
    
    
    sV = round(data_cine.Panel.SliceSlider.Comp.hSlider.Slice.Value);
    J = II{sV};
    [mJ, nJ] = size(J);
% cAF = L.Position;

% convert to ij
cAF(:, 1) = (cAF(:, 1)-data_cine.Image.x0)/data_cine.Image.dx+1;
cAF(:, 2) = (cAF(:, 2)-data_cine.Image.y0)/data_cine.Image.dy+1;

% snakes

L.Visible = 'off';

xMarg = 10;
yMarg = 10;
    
%% rect
xmin = round(min(cAF(:, 1)));
xmax = round(max(cAF(:, 1)));
ymin = round(min(cAF(:, 2)));
ymax = round(max(cAF(:, 2)));

y1 = ymin-yMarg;
y2 = ymax+yMarg;
x1 = xmin-xMarg;
x2 = xmax+xMarg;

T = J(y1:y2, x1:x2);

%% template match
hPlotObj = data_cine.Panel.View.Comp.hPlotObj;

% tumor/diaphram vertical center
mTC = round((mean(data_cine.Tumor.cent.y, 'omitnan')-y0)/dy)+1;
mDP = mean(cAF(:, 2));
mBuffer = round(mJ/10);

CLR = 'rgb';
Tumor = data_cine.Tumor;
% mMid = round(mJ/2);
for iSlice = startSlice:endSlice
    
    if stopSlither
        break;
    end
    
    if data_cine.Tumor.indC(iSlice) > 1 % gating or tracking contour on image
    
        J = II{iSlice};
        if mTC < mDP
            mCut = mTC-mBuffer;
            J2 = J(mCut:end, :);
        else
            mCut = mTC+mBuffer;
            J2 = J(1:mCut, :);
        end

        % template match
        nXC = normxcorr2(T, J2);
        [ypeak, xpeak] = find(nXC==max(nXC(:)));
        yoffSet = ypeak-size(T,1);
        if mTC < mDP
            yoffSet = yoffSet+mCut;
         end
        xoffSet = xpeak-size(T,2);

        C(:, 1) = cAF(:, 1)+xoffSet-x1;
        C(:, 2) = cAF(:, 2)+yoffSet-y1;
                
        % snake on cropped
        if mTC < mDP
            Rect = [xoffSet+1, yoffSet+1, size(T,2), nJ-yoffSet];
        else
            Rect = [xoffSet+1, yoffSet+1, size(T,2), size(T,1)];
        end
        
        if bPlot
            figure(101), clf
            imshow(J, []); 
            axis on;
            hold on
            line(cAF(:, 1), cAF(:, 2), 'Color', 'g')
            line(C(:, 1), C(:, 2), 'Color', 'r')
            rectangle('Position', Rect, 'EdgeColor', 'c');

            figure(102), clf
            imshow(J2, []); 
            axis on;
            hold on
    % %         line(C(:, 1), C(:, 2), 'Color', 'g')
        end
        
        [sC] = fun_findDiaphragm(J, Rect, C);
        % smooth
        % sC(:, 1) = sgolayfilt(sC(:, 1), 3, 75);
        framelen = round(size(sC, 1)/4);
        if mod(framelen, 2) == 0
            framelen = framelen+1;
        end
        framelen = min(framelen, 25);
        sC(:, 2) = sgolayfilt(sC(:, 2), 3, framelen);

    
    else
        sC = [];
    end    

    data_cine.Snake.Snakes{iSlice} = sC;
   
    % tumor snake
    set(data_cine.Panel.View.Comp.hPlotObj.RGBContour, 'XData', Tumor.eContXY{iSlice}(:, 1),...
        'YData', Tumor.eContXY{iSlice}(:, 2), 'Color', CLR(Tumor.indC(iSlice)));
    set(data_cine.Panel.View.Comp.hPlotObj.RGBContourCenter, 'XData', mean(Tumor.eContXY{iSlice}(:, 1)),...
        'YData', mean(Tumor.eContXY{iSlice}(:, 2)), 'Color', CLR(Tumor.indC(iSlice)));

    if Tumor.indC(iSlice) == 1
        set(data_cine.Panel.View.Comp.hPlotObj.SnakeContour, 'XData', [], 'YData', []);
        set(data_cine.Panel.View.Comp.hPlotObj.SnakeContourCenter, 'XData', [], 'YData', []);
    else
        set(data_cine.Panel.View.Comp.hPlotObj.SnakeContour, 'XData', Tumor.snakeContXY{iSlice}(:, 1),...
            'YData', Tumor.snakeContXY{iSlice}(:, 2));
        set(data_cine.Panel.View.Comp.hPlotObj.SnakeContourCenter, 'XData', mean(Tumor.snakeContXY{iSlice}(:, 1)),...
            'YData', mean(Tumor.snakeContXY{iSlice}(:, 2)));
    end

    
    % snake on gui
    data_cine.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
%     hPlotObj.Image.CData = rot90(data.Image.Images{iSlice}, 3);
    hPlotObj.Image.CData = J;
    if isempty(sC)
        hPlotObj.Snake.YData = [];
        hPlotObj.Snake.XData = [];
    else
        hPlotObj.Snake.YData = (sC(:, 2)-1)*dy+y0;
        hPlotObj.Snake.XData = (sC(:, 1)-1)*dx+x0;
    end
    data_cine.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(nSlices)];
    
    % points
    if data_cine.Point.InitDone && ~isempty(sC)
        xi = data_cine.Point.Data.xi;
        ixm = data_cine.Point.Data.ixm;
        NP = data_cine.Point.Data.NP;
        yi = data_cine.Point.Data.yi;

        [~, yi(iSlice, :)] = fun_PointOnCurve(sC, dx, dy, x0, y0, xi, yi(iSlice, :));
        data_cine.Point.Data.yi = yi;

        hPlotObj = data_cine.Panel.View.Comp.hPlotObj;
        hPlotObj.Point.XData = xi(ixm);
        hPlotObj.Point.YData = yi(iSlice, ixm);
        hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
        hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
        hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
        hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
    
        guidata(hFig_cine, data_cine)
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
        data_cine.Snake.SlitherDone = true;

        % enable buttons
        data_cine.Panel.Snake.Comp.Togglebutton.ReDraw.Enable = 'on';
        data_cine.Panel.Snake.Comp.Pushbutton.Delete.Enable = 'on';
        data_cine.Panel.Snake.Comp.Pushbutton.SaveSnake.Enable = 'on';

        data_cine.Panel.Point.Comp.Popup.Neighbour.Enable = 'on';
        data_cine.Panel.Point.Comp.Pushbutton.Init.Enable = 'on';

        data_cine.Panel.Point.Comp.Radiobutton.Tumor.Enable = 'on';
        data_cine.Panel.Point.Comp.Radiobutton.Dome.Enable = 'on';
    end

    guidata(hFig_cine, data_cine);

    src.String = 'Slither';
    src.ForegroundColor = 'g';
    src.Value = 0;
else
    stopSlither = true;
end