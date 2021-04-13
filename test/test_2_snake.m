clearvars

bPlot = 1;
junk = fileparts(pwd);
codePath = fullfile(junk, 'gui_MAXIM');
addpath(codePath);

testImagePath = fullfile(junk, 'gui_MAXIM', 'testImages');
testImageName = 'parsed_data_813_pr002.mat';
ffn = fullfile(testImagePath, testImageName);

dataFileName = 'parsed_data_3799_pr003';
iS = 2778;
testImageFileName = [dataFileName, '_Slice_', num2str(iS)];
load(testImageFileName)


[N, M, ~] = size(imgWrite{1});
if bPlot
    close all
    hF = figure(11);
    MP = get(0, 'MonitorPosition');
    if size(MP, 1) > 1
        hF.Position(1:2) = hF.Position(1:2) + MP(2, 1:2);
    end
    
    x0 = 0;
    y0 = 0;
    dx = 350/N;
    dy = 350/M;
    xWL(1) = x0-dx/2;
    xWL(2) = xWL(1)+dx*N;
    yWL(1) = y0-dy/2;
    yWL(2) = yWL(1)+dy*M;
    RA = imref2d([M N], xWL, yWL);

%     hA = data.Panel.View.Comp.hAxis.Image;
%     hPlotObj.Image = imshow(I, RA, 'parent', hA);
%     axis(data.Panel.View.Comp.hAxis.Image, 'tight', 'equal')
    
    hA(1) = subplot(1,2,1, 'Parent', hF);
    hA(2) = subplot(1,2,2, 'Parent', hF);
    hF.WindowState = 'maximized';
end

% snake params
snakeParam.nIter = 16;
snakeParam.epsilon = 1;
snakeParam.rad = 9;

snakeParam.alpha = 4; % LAC_1
snakeParam.alpha = 1; % LAC_2
snakeParam.alpha = 0.5; % LAC_3


CLR = 'rgb';
tic
for n = 1%1:length(imgWrite)
    
    J = rot90(imgWrite{n}, 3);
%     I = fun_eraseContours(imgWrite{n});
    I = fun_removeContours(J);
    [C, idxC] = fun_extractContour(J);

    if bPlot
        Cxy(:, 1) = (C(:, 1)-1)*dx + x0;
        Cxy(:, 2) = (C(:, 2)-1)*dy + y0;
        imshow(J, RA, 'Parent', hA(1));
        line(hA(1), 'XData', Cxy(:, 1), 'YData', Cxy(:, 2), 'Color', 'm', 'LineStyle', '-', 'Marker', 'o', 'MarkerSize', 2)
        imshow(I, RA,  'Parent', hA(2));
        line(hA(2), 'XData', Cxy(:, 1), 'YData', Cxy(:, 2), 'Color', CLR(idxC), 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 4)
    end
    
    % snake
    mask = poly2mask(C(:, 1), C(:, 2), M, N);
    
%     bw = fun_localAC_MS(ID, mask,...
%             snakeParam.rad, snakeParam.alpha, snakeParam.nIter, snakeParam.epsilon);
%     bw = activecontour(I, mask, 100, 'Chan-Vese', 'SmoothFactor', 3, 'ContractionBias', 0.);

    bw = activecontour(I, mask, 20, 'Chan-Vese', 'SmoothFactor', 3, 'ContractionBias', 0.);
    B = bwboundaries(bw);
    nP = zeros(length(B), 1);
    for m = 1:length(B)
        nP(m) = size(B{m}, 1);
    end
    [~, idx] = max(nP);

    S = fliplr(B{idx});
%     S = B{idx};

    if bPlot
        S(:, 1) = (S(:, 1)-1)*dx + x0;
        S(:, 2) = (S(:, 2)-1)*dy + y0;
        line(hA(2), 'XData', S(:, 1), 'YData', S(:, 2), 'Color', 'm', 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 4)
        
        linkaxes(hA)
        axis(hA, 'on', 'equal', 'tight')
    end

end
toc
