clearvars

bPlot = 1;

junk = fileparts(pwd);
% testImagePath = fullfile(junk, 'gui_MAXIM', 'testImages');
ffn = 'parsed_data_813_pr002.mat';
% ffn = fullfile(testImagePath, testImageName);

load(ffn)

if bPlot
    close all
    hF = figure(11);
    MP = get(0, 'MonitorPosition');
    if size(MP, 1) > 1
        hF.Position(1:2) = hF.Position(1:2) + MP(2, 1:2);
    end
    hA(1) = subplot(1,2,1, 'Parent', hF);
    hA(2) = subplot(1,2,2, 'Parent', hF);
    hF.WindowState = 'maximized';
end

CLR = 'rgb';
tic
for n = 2%:length(imgWrite)
    
    J = imgWrite{n};
    I = fun_eraseContours(J);
   
     if bPlot
        imshow(J, 'Parent', hA(1));
%         line(hA(1), 'XData', C(:, 1), 'YData', C(:, 2), 'Color', 'm', 'LineStyle', '-', 'Marker', 'o', 'MarkerSize', 2)
        imshow(I,  'Parent', hA(2));
%         line(hA(2), 'XData', C(:, 1), 'YData', C(:, 2), 'Color', CLR(idxC), 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 4)
        
        linkaxes(hA)
        axis(hA, 'on', 'equal', 'tight')
    end

end
toc
