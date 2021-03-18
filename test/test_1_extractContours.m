clearvars

junk = fileparts(pwd);
testImagePath = fullfile(junk, 'gui_MAXIM', 'testImages');
testImageName = 'parsed_data_813_pr002.mat';
ffn = fullfile(testImagePath, testImageName);

load(ffn)

hF = figure(11);
MP = get(0, 'MonitorPosition');
    
if size(MP, 1) > 1
    hF.Position(1:2) = hF.Position(1:2) + MP(2, 1:2);
end


for n = 1%:length(imgWrite)
    for  m = 1:3
        hA(m) = subplot(2,3,m, 'parent', hF);
        I = imgWrite{n};
        imshow(I(:,:,m), 'parent', hA(m));
        axis on
        axis equal tight
    end
    linkaxes(hA)
end


nS = 50;
testImageFileName = [dataFileName, '_extract_', num2str(nS)];
ffn_testImage = fullfile(testImagePath, [testImageFileName, '.mat']);

load(ffn_data)
imgWrite = imgWrite(1:nS);
gatedContour = gatedContour(1:nS);
trackContour = trackContour(1:nS);

save(ffn_testImage, 'imgWrite', '*Contour');