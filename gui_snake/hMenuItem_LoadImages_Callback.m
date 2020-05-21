function hMenuItem_LoadImages_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hPanel = data_main.hPanel;
hAxis = data_main.hAxis;
hSlider = data_main.hSlider;

%% load image data
td = tempdir;
fd_info = fullfile(td, 'TaehoTracking');
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

hWB = waitbar(0, 'Loading data...');

data_main.dataPath = dataPath;
data_main.matFile = matFile;

ffn = fullfile(dataPath, matFile);
load(ffn)

%% load image info

data_main.Images = imgWrite;
nImages = length(imgWrite);
[mI, nI, ~] = size(imgWrite{1});
data_main.mI = mI;
data_main.nI = nI;
data_main.nImages = nImages;
data_main.indSS = 1:nImages;
sV = round(nImages/2);
sV = 1;
data_main.sliderValue = sV;
data_main.FreeHandSlice = [];

data_main.gatedContour = gatedContour;
data_main.trackContour = trackContour;
data_main.refContour = refContour;

% image info
data_main.x0 = 0;
data_main.y0 = 0;

data_main.ImageSize = nI;
data_main.FoV = str2num(data_main.hEdit.ImageInfo(1).String);
data_main.dx = data_main.FoV/data_main.ImageSize;
data_main.dy = data_main.dx;

data_main.hEdit.ImageInfo(2).String = num2str(nI);
data_main.hEdit.ImageInfo(2).ForegroundColor = 'c';

data_main.hEdit.ImageInfo(3).String = num2str(data_main.dx);
data_main.hEdit.ImageInfo(3).ForegroundColor = 'c';

% check previously saved snakes
[~, fn1, ~] = fileparts(matFile);
ffn_snakes = fullfile(dataPath, [fn1, '_snakes.mat']);
if exist(ffn_snakes, 'file')
    data_main.hMenuItem.LoadSnakes.Enable = 'on';
end
data_main.ffn_snakes = ffn_snakes;

waitbar(1/3, hWB, 'Initializing GUI...');
%% initialize snake panel
guidata(hFig_main, data_main);
initSnakePanel(hFig_main);
data_main = guidata(hFig_main);

%% data initilization
data_main.cont = cell(nImages, 1);
data_main.maskCont = data_main.cont;
data_main.FreeHand = [];
data_main.FreeHandDone = false;
data_main.SnakeDone = false;
data_main.AllPointDone = false;

waitbar(2/3, hWB, 'Fetching tumor contours...');
%% initialize Tumor panel
guidata(hFig_main, data_main);
initTumorPanel(hFig_main)
data_main = guidata(hFig_main);

data_main.Tumor.indSS = 1:nImages;

%% enable menus
data_main.hMenuItem.FreeHand.Enable = 'on';
data_main.hMenuItem.Tumor.Profile.Enable = 'on';

data_main.hMenuItem.Tumor.bwSum.Checked = 'on';
data_main.hMenuItem.Snake.Enable = 'on';
data_main.hMenuItem.Tumor.bwSum.Enable = 'on';
data_main.hMenuItem.Tumor.TrackContour.Enable = 'on';

%% save
guidata(hFig_main, data_main);

waitbar(1, hWB, 'Bingo!');
pause(2);
close(hWB);