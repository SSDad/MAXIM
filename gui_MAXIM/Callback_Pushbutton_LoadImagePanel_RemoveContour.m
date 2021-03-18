function Callback_Pushbutton_LoadImagePanel_RemoveContour(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

imgs = data.Image.Images;

hWB = waitbar(0, 'Removing contours...');
nImg = length(imgs);
for n = 1:nImg
    I = fun_removeContours(imgs{n});
    waitbar(n/nImg, hWB, 'Removing contours...');
end
close(hWB)