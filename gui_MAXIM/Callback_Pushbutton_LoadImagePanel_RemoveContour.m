function Callback_Pushbutton_LoadImagePanel_RemoveContour(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

imgs = data.Image.Images;

colormap(data.Panel.View.Comp.hAxis.Image, gray);
for iSlice = 1:data.Image.nSlices
    I = fun_removeContours(imgs{iSlice});
    II{iSlice} = rot90(I, 3);

    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
    data.Panel.View.Comp.hPlotObj.Image.CData = II{iSlice};
end
data.Image.Images = II;
data.Image.bContourRemoved = 1;

guidata(hFig, data);