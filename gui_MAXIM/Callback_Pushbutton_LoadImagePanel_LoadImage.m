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

% check previously saved snakes
% [~, fn1, ~] = fileparts(matFile);
% ffn_snakes = fullfile(dataPath, [fn1, '_snakes.mat']);
% if exist(ffn_snakes, 'file')
%     data.hMenuItem.LoadSnakes.Enable = 'on';
% end
% data.ffn_snakes = ffn_snakes;

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
Image.RA = imref2d([M N], xWL, yWL);

data.Panel.View.Comp.hPlotObj.Image.CData = I;
data.Panel.View.Comp.hPlotObj.Image.XData = x0:dx:dx*(N-1);
data.Panel.View.Comp.hPlotObj.Image.YData = y0:dy:dy*(M-1);

data.Panel.View.Comp.hAxis.Image.XLim = [x0 dx*(N-1)];
data.Panel.View.Comp.hAxis.Image.YLim = [y0 dy*(M-1)];
%= imshow(I, RA, 'parent', hAxis.snake);

% slider
hSS = data.Panel.View.Comp.hSlider.Slice;
hSS.Min = 1;
hSS.Max = nImages;
hSS.Value = sV;
hSS.SliderStep = [1 10]/(nImages-1);

data.Panel.View.Comp.hText.nImages.String = [num2str(sV), ' / ', num2str(nImages)];

waitbar(1, hWB, 'Bingo!');
pause(2);
close(hWB);

% contrast
yc = histcounts(I, max(I(:))+1);
yc = log10(yc);
yc = yc/max(yc);
xc = 1:length(yc);
xc = xc/max(xc);

data.Panel.View.Comp.Panel.Constrast.hPlotObj.Hist.XData = xc;
data.Panel.View.Comp.Panel.Constrast.hPlotObj.Hist.YData = yc;

guidata(hFig, data);

% initSnakePanel(hFig);
% data = guidata(hFig);
% 
% %% data initilization
% data.cont = cell(nImages, 1);
% data.maskCont = data.cont;
% data.FreeHand = [];
% data.FreeHandDone = false;
% data.SnakeDone = false;
% data.AllPointDone = false;
% 
% waitbar(2/3, hWB, 'Fetching tumor contours...');
% %% initialize Tumor panel
% guidata(hFig, data);
% initTumorPanel(hFig)
% data = guidata(hFig);
% 
% data.Tumor.indSS = 1:nImages;
% 
% %% enable menus
% data.hMenuItem.FreeHand.Enable = 'on';
% data.hMenuItem.Tumor.Profile.Enable = 'on';
% 
% data.hMenuItem.Tumor.bwSum.Checked = 'on';
% data.hMenuItem.Snake.Enable = 'on';
% data.hMenuItem.Tumor.bwSum.Enable = 'on';
% data.hMenuItem.Tumor.TrackContour.Enable = 'on';
% 
% %% save
% guidata(hFig, data);
% 
