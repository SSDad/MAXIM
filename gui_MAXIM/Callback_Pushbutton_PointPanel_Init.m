function Callback_Pushbutton_PointPanel_Init(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

if ~data.Point.InitDone
dataPath = data.FileInfo.DataPath;
matFile = data.FileInfo.MatFile;

 [~, fn1, ~] = fileparts(matFile);
 ffn = fullfile(dataPath, [fn1, '_Point.mat']);

 if exist(ffn, 'file')
    
    hWB = waitbar(0, 'Loading points...');

    load(ffn)
    xi = Point.xi;
    yi = Point.yi;
    ixm = Point.ixm;
    pause(2);

else

x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;
mI = data.Image.mImgSize;
nI = data.Image.nImgSize;
nImages = data.Image.nImages;

xi = x0:dx:x0+dx*(nI-1);
yi = nan(nImages, nI);
xm = nan(nImages, 1);

hWB = waitbar(0, 'Initializing points on Diaphragm...');

for iSlice = 1:nImages
    C = data.Snake.Snakes{iSlice};
    if ~isempty(C)
        xxh = (C(:, 1)-1)*dx+x0;
        yyh = (C(:, 2)-1)*dy+y0;

    %     mi = round(length(xx)/2);
    %     xi = round(xx(mi));
    %     
    %     yMean = mean(yy);
    %     ind = find(yy>yMean);
    %     yyh = yy(ind);
    %     xxh = xx(ind);

        xm(iSlice) = mean(xxh);

        n1 = ceil((min(xxh)-x0)/dx);
        n2 = floor((max(xxh)-x0)/dx);

        for n = n1:n2
            x1 = [xi(n) xi(n)];
            y1 = [1 1e4];
            [~, yc] = polyxpoly(x1, y1, xxh, yyh);
            if length(yc)>1
                yi(iSlice, n) = max(yc);
            elseif length(yc)==1
                yi(iSlice, n) = yc;
            end
        end
    end
    waitbar(iSlice/nImages, hWB, 'Finding points on Diaphragm...');
end

[~, ixm] = min(abs(xi-nanmean(xm)));

end
waitbar(1, hWB, 'Bingo!');
pause(2);
close(hWB);

data.Point.Data.xi = xi;
data.Point.Data.yi = yi;
data.Point.Data.ixm = ixm;

data.Point.InitDone = true;

else
    xi = data.Point.Data.xi;
    yi = data.Point.Data.yi;
    ixm = data.Point.Data.ixm;
  
end

str = data.Panel.Point.Comp.Popup.Neighbour.String;
idx = data.Panel.Point.Comp.Popup.Neighbour.Value;
NP = str2num(str{idx});
data.Point.Data.NP = NP;

data.Panel.Point.Comp.Togglebutton.Move.Enable = 'on';
data.Panel.Point.Comp.Pushbutton.PointPlot.Enable = 'on';

%% save
guidata(hFig, data);

%% show on snake gui
iSlice = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
if ~isempty(data.Snake.Snakes{iSlice})
    hPlotObj = data.Panel.View.Comp.hPlotObj;
    hPlotObj.Point.XData = xi(ixm);
    hPlotObj.Point.YData = yi(iSlice, ixm);
    hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
    hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
    hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
    hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
end

