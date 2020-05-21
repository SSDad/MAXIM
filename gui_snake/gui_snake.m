function gui_snake

%% global 
global stopSlither
global reContL
global contrastRectLim

%% main window
hFig_main = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'MAXIM - Department of Radiation Oncology, Washington University in St. Louis', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.1 0.1 0.8 0.8],...
                    'Color',                 'black', ...
                    'Visible',               'on');

%% menu
[hToolbar] = addToolbar(hFig_main);
data_main.hToolbar = hToolbar;

[hMenu, hMenuItem] = addMenu(hFig_main);
data_main.hMenu = hMenu;
data_main.hMenuItem = hMenuItem;

%% panel, table
[hPanel, hAxis, hPlotObj, hSlider, hText, hToggleButton, hPushButton, hPopup, hEdit] = addPanel(hFig_main);
data_main.hPanel = hPanel;
data_main.hSlider = hSlider;
data_main.hAxis = hAxis;
data_main.hPlotObj = hPlotObj;
data_main.hText = hText;
data_main.hToggleButton = hToggleButton;
data_main.hPushButton = hPushButton;
data_main.hPopup = hPopup;
data_main.hEdit = hEdit;

data_main.FreeHandDone = false;
data_main.SnakeDone = false;
data_main.LineDone = false;
data_main.tumorLineDone = false;

data_main.Point.Done = false;

%% save
guidata(hFig_main, data_main);                