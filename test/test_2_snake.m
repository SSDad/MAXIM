clearvars

bPlot = 1;

junk = fileparts(pwd);
testImagePath = fullfile(junk, 'gui_MAXIM', 'testImages');
testImageName = 'parsed_data_813_pr002.mat';
ffn = fullfile(testImagePath, testImageName);

load(ffn)

if bPlot
    close all
    hF = figure(11);
    MP = get(0, 'MonitorPosition');
    if size(MP, 1) > 1
        hF.Position(1:2) = hF.Position(1:2) + MP(2, 1:2);
    end
    
    N = 467;
    M = 466;
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

CLR = 'rgb';
tic
for n = 2%:length(imgWrite)
    
    J = rot90(imgWrite{n}, 3);
%     I = fun_eraseContours(imgWrite{n});
    
    I = fun_removeContours(J);
    [C, idxC] = fun_extractContour(J);
    C(:, 1) = (C(:, 1)-1)*dx + x0;
    C(:, 2) = (C(:, 2)-1)*dy + y0;

    if bPlot
        imshow(J, RA, 'Parent', hA(1));
        line(hA(1), 'XData', C(:, 1), 'YData', C(:, 2), 'Color', 'm', 'LineStyle', '-', 'Marker', 'o', 'MarkerSize', 2)
        imshow(I, RA,  'Parent', hA(2));
        line(hA(2), 'XData', C(:, 1), 'YData', C(:, 2), 'Color', CLR(idxC), 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 4)
        
        linkaxes(hA)
        axis(hA, 'on', 'equal', 'tight')
    end

end
toc
