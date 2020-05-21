function hMenuItem_Tumor_Profile_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

CC_GC = data_main.Tumor.CC_GC;
CC_TC = data_main.Tumor.CC_TC;

%% bounding boundary
x1 = inf;
x2 = -inf;
y1 = inf;
y2 = -inf;
for n = 1:length(CC_GC)
    junk{1} = CC_GC{n};
    junk{2} = CC_TC{n};
    for m = 1:2
        if ~isempty(junk{m})
            x1 = min(x1, min(junk{m}(:,1)));
            y1 = min(y1, min(junk{m}(:,2)));
            x2 = max(x2, max(junk{m}(:,1)));
            y2 = max(y2, max(junk{m}(:,2)));
        end
    end
end

%% profile line
marg = 0.2;
xL = x2-x1;
yM = (y1+y2)/2;
pos = [x1-xL*marg  yM
          x2+xL*marg yM];
      
hPL = images.roi.Line(hAxis.Tumor, 'Color', 'c', 'Position', pos , 'Tag', 'PL');
addlistener(hPL, 'MovingROI', @hPL_callback);

hPlotObj.Profile.PL = hPL;

%% initilize profile plot
data_main.hPlotObj = hPlotObj;
guidata(hFig_main, data_main);

updateTumorProfile(data_main);

data_main.hMenuItem.Tumor.Profile.Checked = 'on';