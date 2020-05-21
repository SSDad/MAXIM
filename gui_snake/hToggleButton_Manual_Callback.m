function hToggleButton_Manual_Callback(src, evnt)

global reContL

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

data_main.hPlotObj.maskCont.Visible = 'off';

x0 = data_main.x0;
y0 = data_main.y0;
dx = data_main.dx;
dy = data_main.dy;

bV = src.Value;
iSlice = round(data_main.hSlider.snake.Value);

if bV
    src.String = 'Slither';
    src.ForegroundColor = 'c';

    %     data_main.hSlider.snake.Visible = 'off';
    
%     data_main.hPlotObj.cont.YData = [];
%     data_main.cont{iSlice} = [];

%     src.Visible = 'off';
   
    axes(data_main.hAxis.snake);

    C = data_main.cont{iSlice};
    % convert to xy
    C(:, 1) = (C(:, 1)-1)*dx+x0;
    C(:, 2) = (C(:, 2)-1)*dy+y0;
    
    nWP = size(C, 1);
    WP = false(nWP, 1);
    WP(round(linspace(1, nWP-nWP/14, 14))) = true;
    
    reContL = drawfreehand(data_main.hAxis.snake,...
        'Position', C, 'Closed', 0);%, 'Waypoints', WP);
    
%     L = images.roi.AssistedFreehand(data_main.hAxis.snake);
%     draw(L);
%       pause;

%     src.Visible = 'on';


%     data_main.FreeHand.L = L;
%     data_main.FreeHand.iSlice = iSlice;

else
    
    src.String = 'ReContour';
    src.ForegroundColor = 'g';
%     data_main.hSlider.snake.Visible = 'on';
    
%     L = data_main.FreeHand.L;
   
     I = data_main.hPlotObj.snakeImage.CData;
%     [M, N, ~] = size(I);
    C = reContL.Position;

    
    % convert to ij
    C(:, 1) = (C(:, 1)-data_main.x0)/data_main.dx+1;
    C(:, 2) = (C(:, 2)-data_main.y0)/data_main.dy+1;
    C(:, 1) = sgolayfilt(C(:, 1), 3, 75);
    
%     mask = poly2mask(C(:,1), C(:,2), M, N);
% 
%     windowWidth = 45;
%     polynomialOrder = 3;
%     bw = activecontour(I, mask, 8);
%     B = bwboundaries(bw);
%     
%     nP = [];
%     for m = 1:length(B)
%         nP(m) = size(B{m}, 1);
%     end
%     
%     [~, idx] = max(nP);
%     
%     % smooth
%     sX = sgolayfilt(B{idx}(:, 2), polynomialOrder, windowWidth);
%     sY = sgolayfilt(B{idx}(:, 1), polynomialOrder, windowWidth);
%     data_main.cont{iSlice} = [sX sY];
    
    data_main.cont{iSlice} = C;
%     set(data_main.hPlotObj.cont, 'XData', [], 'YData', []);
    % show
    data_main.hPlotObj.cont.YData = (C(:, 2)-1)*dy+y0;
    data_main.hPlotObj.cont.XData = (C(:, 1)-1)*dx+x0;
    
    reContL.Visible = 'off';

end

guidata(hFig_main, data_main);


% hPlotObj = data_main.hPlotObj;
% 
% if data_main.FreeHandDone
%     data_main.FreeHand.L.Visible = 'off';
%     if  sV == data_main.FreeHand.iSlice
%         data_main.FreeHand.L.Visible = 'on';
%     end
% end
% 
% if data_main.SnakeDone
%     CB =   data_main.cont{sV};
%     data_main.hPlotObj.cont.XData = CB(:, 2);
%     data_main.hPlotObj.cont.YData = CB(:, 1);
% end
% 
% data_main.hText.nImages.String = [num2str(sV), ' / ', num2str(data_main.nImages)];