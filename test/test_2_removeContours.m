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
    hA(1) = subplot(1,2,1, 'Parent', hF);
    hA(2) = subplot(1,2,2, 'Parent', hF);
    hF.WindowState = 'maximized';
end

tic
for n = 2%:length(imgWrite)
%     I = fun_eraseContours(imgWrite{n});
    I = fun_removeContours(imgWrite{n});
end
toc

if bPlot
    imshow(imgWrite{n}, 'Parent', hA(1));
    imshow(I, 'Parent', hA(2));
    linkaxes(hA)
    axis(hA, 'on', 'equal', 'tight')
end

