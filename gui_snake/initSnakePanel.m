function initSnakePanel(hFig_main)

global contrastRectLim

data_main = guidata(hFig_main);
hPanel = data_main.hPanel;
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;
Images = data_main.Images;

hAxis.snake = axes('Parent',                   hPanel.snake, ...
                            'color',        'none',...
                            'Units',                    'normalized', ...
                            'HandleVisibility',     'callback', ...
                            'Position',                 [0. 0. 1. 1.]);
hold(hAxis.snake, 'on');

% CT images
sV = data_main.sliderValue;
nImages = data_main.nImages;

I = rot90(Images{sV}, 3);
[M, N, ~] = size(I);

x0 = data_main.x0;
y0 = data_main.y0;
dx = data_main.dx;
dy = data_main.dy;
xWL(1) = x0-dx/2;
xWL(2) = xWL(1)+dx*N;
yWL(1) = y0-dy/2;
yWL(2) = yWL(1)+dy*M;
RA = imref2d([M N], xWL, yWL);

data_main.RA = RA;

hPlotObj.snakeImage = imshow(I, RA, 'parent', hAxis.snake);

% contrast bar
yc = histcounts(I, max(I(:))+1);
yc = log10(yc);
yc = yc/max(yc);
xc = 1:length(yc);
xc = xc/max(xc);

hPlotObj.Contrast.Hist = line(hAxis.Contrast,...
    'XData', xc, 'YData', yc, 'Color', 'w', 'LineStyle', '-', 'LineWidth', 1);
hPlotObj.Contrast.Rect =images.roi.Rectangle(hAxis.Contrast,...
    'Position',[0, 0,1, 1], 'FaceAlpha', 0.3);
addlistener(hPlotObj.Contrast.Rect, 'MovingROI', @hContrastRect_callback);

hAxis.Contrast.XLim = [0 1];
hAxis.Contrast.YLim = [0 1];

contrastRectLim = [0 1];

% contour
hPlotObj.cont = line(hAxis.snake,...
    'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 3);
hPlotObj.maskCont = line(hAxis.snake,...
    'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 1);

% point on diaphragm
hPlotObj.Point = line(hAxis.snake,...
    'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
    'Marker', '.', 'MarkerSize', 24);

hPlotObj.LeftPoints = line(hAxis.snake,...
        'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
        'Marker', '.', 'MarkerSize', 16);

hPlotObj.RightPoints = line(hAxis.snake,...
        'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', 'none',...
        'Marker', '.', 'MarkerSize', 16);

% image number text
data_main.hText.nImages.String = [num2str(sV), ' / ', num2str(nImages)];

% slider
hSlider = data_main.hSlider;
hSlider.snake.Min = 1;
hSlider.snake.Max = nImages;
hSlider.snake.Value = sV;
hSlider.snake.SliderStep = [1 10]/(nImages-1);

data_main.hText.nImages.Visible = 'on';
data_main.hSlider.snake.Visible = 'on';

%% save data
data_main.hAxis = hAxis;
data_main.hPlotObj = hPlotObj;
guidata(hFig_main, data_main);
