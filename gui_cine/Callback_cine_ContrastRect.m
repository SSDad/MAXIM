function Callback_cine_ContrastRect(src, evnt)

global contrastRectLim_cine

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

recPos = src.Position;
% I = hPlotObj.snakeImage.CData;
Images = data.Image.Images;
% sV = data_main.sliderValue;
sV = round(data.Panel.SliceSlider.Comp.hSlider.Slice.Value);
% I = rot90(Images{sV}, 3);
I = Images(:,:,sV);

contrastRectLim_cine(1) = recPos(1);
contrastRectLim_cine(2) = contrastRectLim_cine(1)+recPos(3);
maxI = max(I(:));
minI = min(I(:));
wI = maxI-minI;

cL1 = minI+wI*contrastRectLim_cine(1);
cL2 = minI+wI*contrastRectLim_cine(2);

I(I<cL1) = cL1;
I(I>cL2) = cL2;
data.Panel.View.Comp.hPlotObj.Image.CData = I;