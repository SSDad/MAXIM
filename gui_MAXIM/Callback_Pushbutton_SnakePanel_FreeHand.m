function Callback_Pushbutton_SnakePanel_FreeHand(src, evnt)

global hFig hFig2 contrastRectLim

data = guidata(hFig);

%% slice No.
startSlice = str2double(data.Panel.Snake.Comp.Edit.StartSlice.String);
endSlice = str2double(data.Panel.Snake.Comp.Edit.EndSlice.String);

hSlider = data.Panel.SliceSlider.Comp.hSlider.Slice;
iSlice = round(hSlider.Value);

if iSlice < startSlice | iSlice > endSlice
    iSlice = startSlice;
    hSlicer.Value = iSlice;
    data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(data.Image.nImages)];

    % image
    I = rot90(data.Image.Images{iSlice}, 3);

    % contrast limit
    maxI = max(I(:));
    minI = min(I(:));
    wI = maxI-minI;
    cL1 = minI+wI*contrastRectLim(1);
    cL2 = minI+wI*contrastRectLim(2);
    I(I<cL1) = cL1;
    I(I>cL2) = cL2;

    hPlotObj = data.Panel.View.Comp.hPlotObj;
    hPlotObj.Image.CData = I;
end

% data.Snake.FreeHand.iSlice = round(hSlider.Value);

hA = data.Panel.View.Comp.hAxis.Image;
% uistack(hA, 'top');

axis(hA);
L = images.roi.AssistedFreehand(hA,...
    'Image', data.Panel.View.Comp.hPlotObj.Image, ...
    'Closed', 0);
% L = images.roi.AssistedFreehand('Image', data.Panel.View.Comp.hPlotObj.Image, ...
%     'Closed', 0);
draw(L);

data.Snake.FreeHand.L = L;
data.Snake.FreeHand.Done = true;

data.Panel.Snake.Comp.Togglebutton.Slither.Enable = 'on';
data.Panel.Snake.Comp.Togglebutton.Slither.ForegroundColor = 'g';

%% save
guidata(hFig, data);                