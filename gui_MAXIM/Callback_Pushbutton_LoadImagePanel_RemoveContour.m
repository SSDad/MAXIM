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
    [C, idxC] = fun_extractContour(J);
    eCont{iSlice} = C;
    indC(iSlice) = idxC;
    C(:, 1) = (C(:, 1)-1)*dx + x0;
    C(:, 2) = (C(:, 2)-1)*dy + y0;
    eContXY{iSlice} = C;

    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
    data.Panel.View.Comp.hPlotObj.Image.CData = II{iSlice};
    
%     if idxC == 2 || idxC == 3
        set(data.Panel.View.Comp.hPlotObj.RGBContour, 'XData', C(:, 1), 'YData', C(:, 2), 'Color', CLR(idxC));
%     else
%         set(data.Panel.View.Comp.hPlotObj.RGBContour, 'XData', [], 'YData', []);
%     end
    drawnow
end
data.Image.Images = II;
data.Image.eCont = eCont;
data.Image.indC = indC;
data.Image.eContXY = eContXY;
data.Image.bContourRemoved = 1;

guidata(hFig, data);