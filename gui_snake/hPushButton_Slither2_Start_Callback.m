function hPushButton_Slither2_Start_Callback(src, evnt)

global stopSlither

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

x0 = data_main.x0;
y0 = data_main.y0;
dx = data_main.dx;
dy = data_main.dy;

II = data_main.Images;
% sV = round(data_main.hSlider.snake.Value);
sV= data_main.FreeHand.iSlice;

data_main.hSlider.snake.Value = sV;
hPlotObj.snakeImage.CData = rot90(data_main.Images{sV}, 3);
data_main.hText.nImages.String = [num2str(sV), ' / ', num2str(data_main.nImages)];
drawnow;

% if isempty(data_main.FreeHandSlice)
%     data_main.FreeHandSlice = sV;
% else
%     sV = data_main.FreeHandSlice;
% end

% sV = 1;
J =  rgb2gray(II{sV});
J = rot90(J, 3);
[M, N] = size(J);

% sgolay filter param
% windowWidth =  round(N/15)*2+1;
% polynomialOrder = 3;

str = data_main.hPopup.SGolayParam(1).String;
idx = data_main.hPopup.SGolayParam(1).Value;
windowWidth = str2num(str{idx});
str = data_main.hPopup.SGolayParam(2).String;
idx = data_main.hPopup.SGolayParam(2).Value;
polynomialOrder = str2num(str{idx});

% snake params
str = data_main.hPopup.SnakeParam(1).String;
idx = data_main.hPopup.SnakeParam(1).Value;
nIter = str2num(str{idx});

str = data_main.hPopup.SnakeParam(2).String;
idx = data_main.hPopup.SnakeParam(2).Value;
contractionBias = str2num(str{idx});

str = data_main.hPopup.SnakeParam(3).String;
idx = data_main.hPopup.SnakeParam(3).Value;
smoothFactor = str2num(str{idx});

snakeParam.nIter = nIter;
snakeParam.contractionBias = contractionBias;
snakeParam.smoothFactor = smoothFactor;

% First slice
L = data_main.FreeHand.L;
L.Visible = 'off';
FC = L.Position;
hPlotObj.maskCont.XData = FC(:, 1);
hPlotObj.maskCont.YData = FC(:, 2);

% convert to ij
FCij(:, 1) = (FC(:, 1)-data_main.x0)/data_main.dx+1;
FCij(:, 2) = (FC(:, 2)-data_main.y0)/data_main.dy+1;

% smooth
FCijs(:, 1) = sgolayfilt(FCij(:, 1), polynomialOrder, windowWidth);
FCijs(:, 2) = sgolayfilt(FCij(:, 2), polynomialOrder, windowWidth);
MC1 = FCijs;
mask1 = poly2mask(MC1(:, 1), MC1(:,2), M, N);
data_main.maskCont{sV} = FCijs;

[SCij] = fun_aac1(J, FCijs, snakeParam);

    % smooth
    SCijs(:, 1) = sgolayfilt(SCij(:, 1), polynomialOrder, windowWidth);
    SCijs(:, 2) = sgolayfilt(SCij(:, 2), polynomialOrder, windowWidth);


% mask = poly2mask(FCijs(:,1), FCijs(:,2), M, N);
% 
% 
% % snake
% % bw = activecontour(J, mask, 10);
% bw = activecontour(J, mask, nIter, 'Chan-Vese',...
%         'SmoothFactor', smoothFactor, 'ContractionBias', contractionBias);
% 
% B = bwboundaries(bw);
% nP = [];
% for m = 1:length(B)
%     nP(m) = size(B{m}, 1);
% end
% [~, idx] = max(nP);
% 
% SC = fliplr(B{idx});
data_main.cont{sV} = SCijs; %save in pixel s

% show
data_main.hSlider.snake.Value = sV;
hPlotObj.snakeImage.CData = rot90(data_main.Images{sV}, 3);

hPlotObj.cont.XData = SCijs(:, 1)*dy+y0;
hPlotObj.cont.YData = SCijs(:, 2)*dx+x0;

clear SC*;

%% snakes
% hWB = waitbar(0, 'Snake slithering...');
nImages = length(II);

delta.Area = [];
delta.XOR = [];
delta.Area1 = zeros(nImages, 1);
delta.XOR1 = zeros(nImages, 1);

% up
for n = sV+1:nImages
    J =  rgb2gray(II{n});
    J = rot90(J, 3);
    
    MC = data_main.cont{n-1};
    data_main.maskCont{n} = MC;
    hPlotObj.maskCont.XData = MC(:, 1)*dy+y0;
    hPlotObj.maskCont.YData = MC(:, 2)*dx+x0;

[SCij, delta.Area1(n), delta.XOR1(n), dA, dXOR] = fun_aac(J, MC, snakeParam, MC1, mask1);

delta.Area = [delta.Area; dA];
delta.XOR = [delta.XOR; dXOR];

    % smooth
    SCijs(:, 1) = sgolayfilt(SCij(:, 1), polynomialOrder, windowWidth);
    SCijs(:, 2) = sgolayfilt(SCij(:, 2), polynomialOrder, windowWidth);

    data_main.cont{n} = SCijs;
%     waitbar((n-sV)/nImages, hWB);
    
    data_main.hSlider.snake.Value = n;
    hPlotObj.snakeImage.CData = rot90(data_main.Images{n}, 3);
    hPlotObj.cont.XData = SCijs(:, 1)*dx+x0;
    hPlotObj.cont.YData = SCijs(:, 2)*dy+y0;
    data_main.hText.nImages.String = [num2str(n), ' / ', num2str(data_main.nImages)];
    drawnow;
   
    clear SC*;
    
    if stopSlither
        stopSlither = false;
        break;
    end
    
end

% down
if sV > 1
    for n = sV-1:-1:1
        J =  rgb2gray(II{n});
        J = rot90(J, 3);
        
        MC = data_main.cont{n+1};
        data_main.maskCont{n} = MC;
        hPlotObj.maskCont.XData = MC(:, 1)*dy+y0;
        hPlotObj.maskCont.YData = MC(:, 2)*dx+x0;

        [SCij, delta.Area1(n), delta.XOR1(n), dA, dXOR] = fun_aac(J, MC, snakeParam, MC1, mask1);

        delta.Area = [delta.Area; dA];
        delta.XOR = [delta.XOR; dXOR];

        % smooth
        SCijs(:, 1) = sgolayfilt(SCij(:, 1), polynomialOrder, windowWidth);
        SCijs(:, 2) = sgolayfilt(SCij(:, 2), polynomialOrder, windowWidth);

        data_main.cont{n} = SCijs;
    %     waitbar((n-sV)/nImages, hWB);

        data_main.hSlider.snake.Value = n;
        hPlotObj.snakeImage.CData = rot90(data_main.Images{n}, 3);
        hPlotObj.cont.XData = SCijs(:, 1)*dx+x0;
        hPlotObj.cont.YData = SCijs(:, 2)*dy+y0;
        data_main.hText.nImages.String = [num2str(n), ' / ', num2str(data_main.nImages)];
        drawnow;

        clear SC*;

        if stopSlither
            stopSlither = false;
            break;
        end
    end
end

% close(hWB);

data_main.SnakeDone = true;

SCijs =   data_main.cont{n};
hPlotObj.cont.XData = SCijs(:, 1)*dx+x0;
hPlotObj.cont.YData = SCijs(:, 2)*dy+y0;

MC = data_main.maskCont{n};
hPlotObj.maskCont.XData = MC(:, 1)*dy+y0;
hPlotObj.maskCont.YData = MC(:, 2)*dx+x0;

% visboundaries(data_main.hAxis.snake, bw, 'Color', 'r'); 

%% save
guidata(hFig_main, data_main);                