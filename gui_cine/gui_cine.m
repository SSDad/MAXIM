function gui_cine

%% global 
global hFig_cine

% global stopSlither
% global reContL
% global contrastRectLim

%% main window

hFig_cine = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'MAXgRT - CINE', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.1 0.1 0.8 0.8],...
                    'Color',                 'black', ...
                    'CloseRequestFcn', @figCloseReq_cine, ...
                    'Visible',               'on');

addToolbar_cine(hFig_cine);
%                 
data_cine.Panel = addPanel_cine(hFig_cine);
data_cine.Panel.LoadImage.Comp = addComponents2Panel_cine_LoadImage(data_cine.Panel.LoadImage.hPanel);
% data.Panel.Selection.Comp = addComponents2Panel_Selection(data.Panel.Selection.hPanel);
data_cine.Panel.View.Comp = addComponents2Panel_cine_View(data_cine.Panel.View.hPanel);
data_cine.Panel.Snake.Comp = addComponents2Panel_cine_Snake(data_cine.Panel.Snake.hPanel);
% data.Panel.Body.Comp = addComponents2Panel_Body(data.Panel.Body.hPanel);
data_cine.Panel.ContrastBar.Comp = addComponents2Panel_cine_ContrastBar(data_cine.Panel.ContrastBar.hPanel);
data_cine.Panel.SliceSlider.Comp = addComponents2Panel_cine_SliceSlider(data_cine.Panel.SliceSlider.hPanel);
% 
% data.Panel.Point.Comp = addComponents2Panel_Point(data.Panel.Point.hPanel);
% 
% data.Panel.About.Comp = addComponents2Panel_About(data.Panel.About.hPanel);
% 
% data.FC = [255 255 102]/255;
% data.ActiveAxis.MovePoints = 0;
% 
guidata(hFig_cine, data_cine);
% 
% %% point fig
% hFig2 = figure('MenuBar',            'none', ...
%                     'Toolbar',              'none', ...
%                     'HandleVisibility',  'callback', ...
%                     'Name',                'MAXIM - Diaphragm Measurement', ...
%                     'NumberTitle',      'off', ...
%                     'Units',                 'normalized',...
%                     'Position',             [0.05 0.05 0.9 0.85],...
%                     'Color',                 'black', ...
%                     'CloseRequestFcn', @fig2CloseReq, ...
%                     'Visible',               'off');
% 
% addToolbar(hFig2);
% data2.Panel = addPanel2(hFig2);
% data2.Panel.View.Comp = addComponents2Panel2_View(data2.Panel.View.hPanel);
% data2.Panel.Tumor.Comp = addComponents2Panel2_Tumor(data2.Panel.Tumor.hPanel);
% data2.Panel.Button.Comp = addComponents2Panel2_Button(data2.Panel.Button.hPanel);
% data2.Panel.Button1.Comp = addComponents2Panel2_Button1(data2.Panel.Button1.hPanel);
% data2.Panel.Profile.Comp = addComponents2Panel2_Profile(data2.Panel.Profile.hPanel);
% guidata(hFig2, data2);
%                                
