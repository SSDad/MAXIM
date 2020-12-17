clearvars

dataPath = 'X:\Lab\VR_VG_Pancreas_Ben\Cine\1';
dataFileName = 'parsed_data_5183_pr001';
ffn_data = fullfile(dataPath, [dataFileName, '.mat']);

testImagePath = 'H:\MAXIM\gui_MAXIM\testImages';
nS = 20;
testImageFileName = [dataFileName, '_extract_', num2str(nS)];
ffn_testImage = fullfile(testImagePath, [testImageFileName, '.mat']);

load(ffn_data)
imgWrite = imgWrite(1:nS);
gatedContour = gatedContour(1:nS);
trackContour = trackContour(1:nS);

save(ffn_testImage, 'imgWrite', '*Contour');