function Callback_Pushbutton_LoadImagePanel_LoadImage(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

%% load image data
td = tempdir;
fd_info = fullfile(td, 'MAXIM');
fn_info = fullfile(fd_info, 'info.mat');
if ~exist(fd_info, 'dir')
    [matFile, dataPath] = uigetfile('*.mat');
    mkdir(fd_info);
    save(fn_info, 'dataPath');
else
    if ~exist(fn_info, 'file')
        [matFile, dataPath] = uigetfile('*.mat');
        save(fn_info, 'dataPath');
    else
        load(fn_info);
        [matFile, ~] = uigetfile([dataPath, '*.mat']);
    end
end

hWB = waitbar(0, 'Loading Images...');

ffn = fullfile(dataPath, matFile);
load(ffn)

data.FileInfo.DataPath = dataPath;
data.FileInfo.MatFile = matFile;

%% load image info
Image.Images = imgWrite;
nImages = length(imgWrite);
[mImgSize, nImgSize, ~] = size(imgWrite{1});
Image.mImgSize = mImgSize;
Image.nImgSize = nImgSize;
Image.nImages = nImages;

Image.indSS = 1:nImages;
Image.SliderValue = 1;
Image.FreeHandSlice = [];

Image.GatedContour = gatedContour;
Image.TrackContour = trackContour;
Image.RefContour = refContour;
% image info
Image.x0 = 0;
Image.y0 = 0;

Image.FoV = str2num(data.Panel.LoadImage.Comp.hEdit.ImageInfo(1).String);
Image.dx = Image.FoV/nImgSize;
Image.dy = Image.dx;

data.Image = Image;

data.Panel.LoadImage.Comp.hEdit.ImageInfo(2).String = num2str(nImgSize);
data.Panel.LoadImage.Comp.hEdit.ImageInfo(2).ForegroundColor = 'c';

data.Panel.LoadImage.Comp.hEdit.ImageInfo(3).String = num2str(Image.dx);
data.Panel.LoadImage.Comp.hEdit.ImageInfo(3).ForegroundColor = 'c';

%check previously saved snakes
[~, fn1, ~] = fileparts(matFile);
ffn_snakes = fullfile(dataPath, [fn1, '_Snake.mat']);
data.FileInfo.ffn_snakes = ffn_snakes;
if exist(ffn_snakes, 'file')
    data.Panel.Snake.Comp.Pushbutton.LoadSnake.Enable = 'on';
end
ffn_points = fullfile(dataPath, [fn1, '_Point.mat']);
data.FileInfo.ffn_points = ffn_points;

data.Panel.Snake.Comp.Pushbutton.FreeHand.Enable = 'on';

waitbar(1/3, hWB, 'Initializing View...');

% CT images
sV = 1;
nImages = data.Image.nImages;

I = rot90(Image.Images{sV}, 3);
[M, N, ~] = size(I);

x0 = Image.x0;
y0 = Image.y0;
dx = Image.dx;
dy = Image.dy;
xWL(1) = x0-dx/2;
xWL(2) = xWL(1)+dx*N;
yWL(1) = y0-dy/2;
yWL(2) = yWL(1)+dy*M;
RA = imref2d([M N], xWL, yWL);

hA = data.Panel.View.Comp.hAxis.Image;
hPlotObj.Image = imshow(I, RA, 'parent', hA);
axis(data.Panel.View.Comp.hAxis.Image, 'tight', 'equal')

% snake
hPlotObj.Snake = line(hA,...
    'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 3);
hPlotObj.SnakeMask = line(hA,...
    'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 1);

% point on diaphragm
hPlotObj.Point = line(hA,...
    'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
    'Marker', '.', 'MarkerSize', 24);

hPlotObj.LeftPoints = line(hA,...
        'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
        'Marker', '.', 'MarkerSize', 16);

hPlotObj.RightPoints = line(hA,...
        'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
        'Marker', '.', 'MarkerSize', 16);
    
data.Panel.View.Comp.hPlotObj = hPlotObj;

% slider
hSS = data.Panel.SliceSlider.Comp.hSlider.Slice;
hSS.Min = 1;
hSS.Max = nImages;
hSS.Value = sV;
hSS.SliderStep = [1 10]/(nImages-1);

data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(sV), ' / ', num2str(nImages)];

waitbar(1, hWB, 'Bingo!');
pause(2);
close(hWB);

% contrast
yc = histcounts(I, max(I(:))+1);
yc = log10(yc);
yc = yc/max(yc);
xc = 1:length(yc);
xc = xc/max(xc);

data.Panel.ContrastBar.Comp.hPlotObj.Hist.XData = xc;
data.Panel.ContrastBar.Comp.hPlotObj.Hist.YData = yc;

data.Point.InitDone = false;

guidata(hFig, data);