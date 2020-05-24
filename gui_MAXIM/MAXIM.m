function MAXIM

%% global 
global stopSlither
global reContL
global contrastRectLim

%% main window
hFig = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'MAXIM - Department of Radiation Oncology, Washington University in St. Louis', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.1 0.1 0.6 0.8],...
                    'Color',                 'black', ...
                    'Visible',               'on');

                
data.Panel = addPanel(hFig);
data.Panel.LoadImage.Comp = addComponents2Panel_LoadImage(data.Panel.LoadImage.hPanel);
data.Panel.View.Comp = addComponents2Panel_View(data.Panel.View.hPanel);
data.Panel.Snake.Comp = addComponents2Panel_Snake(data.Panel.Snake.hPanel);
data.Panel.ContrastBar.Comp = addComponents2Panel_ContrastBar(data.Panel.ContrastBar.hPanel);
data.Panel.SliceSlider.Comp = addComponents2Panel_SliceSlider(data.Panel.SliceSlider.hPanel);

guidata(hFig, data);
                               
