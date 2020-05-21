function hContrastRect_callback(src, evnt)

global contrastRectLim

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

recPos = src.Position;
% I = hPlotObj.snakeImage.CData;
Images = data_main.Images;
% sV = data_main.sliderValue;
sV = round(data_main.hSlider.snake.Value);
I = rot90(Images{sV}, 3);

contrastRectLim(1) = recPos(1);
contrastRectLim(2) = contrastRectLim(1)+recPos(3);
maxI = max(I(:));
minI = min(I(:));
wI = maxI-minI;

cL1 = minI+wI*contrastRectLim(1);
cL2 = minI+wI*contrastRectLim(2);

I(I<cL1) = cL1;
I(I>cL2) = cL2;
hPlotObj.snakeImage.CData = I;