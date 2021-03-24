function Callback_Pushbutton_LoadImagePanel_RemoveContour(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

Image = data.Image;
nSlices = Image.nSlices;

x0 = Image.x0;
y0 = Image.y0;
dx = Image.dx;
dy = Image.dy;

% gatedContour = Image.GatedContour;
% trackContour = Image.TrackContour;
% 
imgs = data.Image.Images;
colormap(data.Panel.View.Comp.hAxis.Image, gray);
CLR = 'rgb';
for iSlice = 1:nSlices
    
    J = rot90(imgs{iSlice}, 3);
    II{iSlice} = fun_removeContours(J);
    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
    data.Panel.View.Comp.hPlotObj.Image.CData = II{iSlice};
    
    [C, idxC] = fun_extractContour(J);
    eCont{iSlice} = C;
    indC(iSlice) = idxC;
    
    % snake
    snakeCont{iSlice} = [];
    snakeContXY{iSlice} = [];
    set(data.Panel.View.Comp.hPlotObj.SnakeContour, 'XData', [], 'YData', []);
    set(data.Panel.View.Comp.hPlotObj.SnakeContourCenter, 'XData', [], 'YData', []);
    if idxC > 1
        mask = poly2mask(C(:, 1), C(:, 2), Image.nImgSize, Image.mImgSize);
        bw = activecontour(II{iSlice}, mask, 20, 'Chan-Vese', 'SmoothFactor', 3, 'ContractionBias', 0.);

        B = bwboundaries(bw);
        nP = zeros(length(B), 1);
        for m = 1:length(B)
            nP(m) = size(B{m}, 1);
        end
        [~, idx] = max(nP);
        S = fliplr(B{idx});
        snakeCont{iSlice} = S;

        S(:, 1) = (S(:, 1)-1)*dx + x0;
        S(:, 2) = (S(:, 2)-1)*dy + y0;
        snakeContXY{iSlice} = S;
        set(data.Panel.View.Comp.hPlotObj.SnakeContour, 'XData', S(:, 1), 'YData', S(:, 2));
        set(data.Panel.View.Comp.hPlotObj.SnakeContourCenter, 'XData', mean(S(:, 1)), 'YData', mean(S(:, 2)));
    end
    
    % extracted contour in xy
    C(:, 1) = (C(:, 1)-1)*dx + x0;
    C(:, 2) = (C(:, 2)-1)*dy + y0;
    eContXY{iSlice} = C;

    set(data.Panel.View.Comp.hPlotObj.RGBContour, 'XData', C(:, 1), 'YData', C(:, 2), 'Color', CLR(idxC));
    set(data.Panel.View.Comp.hPlotObj.RGBContourCenter, 'XData', mean(C(:, 1)), 'YData', mean(C(:, 2)), 'Color', CLR(idxC));

    drawnow
end
data.Image.Images = II;
data.Image.eCont = eCont;
data.Image.indC = indC;
data.Image.eContXY = eContXY;
data.Image.snakeCont = snakeCont;
data.Image.snakeContXY = snakeContXY;
data.Image.bContourRemoved = 1;

guidata(hFig, data);