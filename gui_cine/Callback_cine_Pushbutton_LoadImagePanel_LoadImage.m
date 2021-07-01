function Callback_cine_Pushbutton_LoadImagePanel_LoadImage(src, evnt)

hFig = ancestor(src, 'Figure');
data_cine = guidata(hFig);

%% load image data
td = tempdir;
fd_info = fullfile(td, 'MAXIM');
fn_info = fullfile(fd_info, 'info_cine.mat');
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
        [matFile, dataPath] = uigetfile([dataPath, '*.mat']);
        save(fn_info, 'dataPath');
    end
end

% if matFile ~=0
    data_cine.FileInfo.DataPath = dataPath;
    data_cine.FileInfo.MatFile = matFile;
    
    hWB = waitbar(0, 'Loading Images...');
    
    ffn = fullfile(dataPath, matFile);
    load(ffn);
    
    Image.Images = cineData;
    [mImgSize, nImgSize, nSlices] = size(cineData);

    Image.mImgSize = mImgSize;
    Image.nImgSize = nImgSize;
    Image.nSlices = nSlices;

    Image.indSS = 1:nSlices;
    Image.SliderValue = 1;
    
 
    % CT images
    iSlice = 1;
    I = Image.Images(:,:,1);
    
    x0 = 0;
    y0 = 0;
    dx = 0.1;
    dy = 0.1;
    Image.x0 = x0;
    Image.y0 = y0;
    Image.dx = dx ;
    Image.dy = dy;
    xWL(1) = x0-dx/2;
    xWL(2) = xWL(1)+dx*nImgSize;
    yWL(1) = y0-dy/2;
    yWL(2) = yWL(1)+dy*mImgSize;
    RA = imref2d([mImgSize nImgSize], xWL, yWL);
    Image.RA = RA;

    data_cine.Image = Image;

    
    hA = data_cine.Panel.View.Comp.hAxis.Image;
    hPlotObj.Image = imshow(I, RA, [], 'parent', hA);
    axis(data_cine.Panel.View.Comp.hAxis.Image, 'tight', 'equal')

    
    % snake
    hPlotObj.Snake = line(hA,...
        'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', '-', 'LineWidth', 2);
%     hPlotObj.SnakeMask = line(hA,...
%         'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 1);

    pos = [0 0 0 0];
    hPlotObj.SnakeRect = rectangle(hA, 'Position', pos, 'EdgeColor', 'b',...
        'LineWidth', .1, 'Tag', 'SnakeRect', 'Visible', 'off');

    hPlotObj.TMRect = rectangle(hA, 'Position', pos, 'EdgeColor', 'b',...
        'LineWidth', .1, 'Tag', 'TMRect', 'Visible', 'off');

%     % point on diaphragm
%     hPlotObj.Point = line(hA,...
%         'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%         'Marker', '.', 'MarkerSize', 24);
% 
%     hPlotObj.LeftPoints = line(hA,...
%             'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%             'Marker', '.', 'MarkerSize', 16);
% 
%     hPlotObj.RightPoints = line(hA,...
%             'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
%             'Marker', '.', 'MarkerSize', 16);

%     pos = [x0 y0+yWL(2)/3 xWL(2) yWL(2)/3];
%     hPlotObj.AbRect = images.roi.Rectangle(hA, 'Position', pos, 'Color', 'g',...
%         'LineWidth', .5, 'FaceAlpha', 0.1, 'Tag', 'AbRec', 'Visible', 'off');
%     addlistener(hPlotObj.AbRect, 'MovingROI', @Callback_AbRect);
%     
%     x1 = pos(1);
%     x2 = x1+pos(3);
%     y1 = pos(2)+pos(4)/2;
%     y2 = y1;
%     hPlotObj.AbRectCLine = images.roi.Line(hA, 'Position',[x1 y1; x2 y2], 'Color', 'c',...
%         'LineWidth', 1, 'Tag', 'AbRecCLine', 'Visible', 'off');
%     addlistener(hPlotObj.AbRectCLine, 'MovingROI', @Callback_AbRectCLine);
  
    data_cine.Panel.View.Comp.hPlotObj = hPlotObj;

    %% slider
    hSS = data_cine.Panel.SliceSlider.Comp.hSlider.Slice;
    hSS.Min = 1;
    hSS.Max = nSlices;
    hSS.Value = iSlice;
    hSS.SliderStep = [1 10]/(nSlices-1);

    data_cine.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(nSlices)];

    waitbar(1, hWB, 'All slices are loaded!');
    pause(1);
    close(hWB);

    %% contrast
    yc = histcounts(I, max(I(:))+1);
    yc = log10(yc);
    yc = yc/max(yc);
    xc = 1:length(yc);
    xc = xc/max(xc);

    data_cine.Panel.ContrastBar.Comp.hPlotObj.Hist.XData = xc;
    data_cine.Panel.ContrastBar.Comp.hPlotObj.Hist.YData = yc;

%     data_cine.Snake.SlitherDone = false;
%     data_cine.Point.InitDone = false;
%     data_cine.Tumor.InitDone = false;
%     data_cine.Body.ContourDone = false;

    guidata(hFig, data_cine);
