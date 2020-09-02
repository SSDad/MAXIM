function Callback_Pushbutton_BodyPanel_LoadContour(src, evnt)

global hFig hFig2

% hFig = ancestor(src, 'Figure');
data = guidata(hFig);
data2 = guidata(hFig2);

ffn_AbsContour = data.FileInfo.ffn_AbsContour;
load(ffn_AbsContour);
data.Body.AbsContour = AbsContour;

% show contour
x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;

iSlice = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);

    abC2 = data.Body.AbsContour{iSlice};
    hPlotObj = data.Panel.View.Comp.hPlotObj;
%         hPlotObj.Body.YData = (bC(:, 1)-1)*dy+y0;
%         hPlotObj.Body.XData = (bC(:, 2)-1)*dx+x0;
        hPlotObj.Ab.YData = (abC2(:, 1)-1)*dy+y0;
        hPlotObj.Ab.XData = (abC2(:, 2)-1)*dx+x0;
    
        data.Body.ContourDone = true;
guidata(hFig, data)