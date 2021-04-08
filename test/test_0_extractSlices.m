clearvars

dataPath = 'X:\Lab\VR_VG_Pancreas_Ben\Cine\1';
dataFileName = 'parsed_data_5183_pr001';
dataFileName = 'parsed_data_5151_pr001';

dataPath = 'X:\Lab\BugReport\jaeik';
dataFileName = 'parsed_data_3628_pr001';
testImagePath = 'H:\MAXIM\gui_MAXIM\testImages_lung';

dataPath = 'D:\Zhen\Box Sync\BugReport_MAXIM\Anamaria\11_didnt generate the snake\4675_pr001';
dataFileName = 'parsed_data_4675_pr001';
testImagePath = 'D:\Zhen\Box Sync\BugReport_MAXIM\testImages_lung';

ffn_data = fullfile(dataPath, [dataFileName, '.mat']);

nS = 100;
testImageFileName = [dataFileName, '_extract_', num2str(nS)];
ffn_testImage = fullfile(testImagePath, [testImageFileName, '.mat']);

load(ffn_data)
imgWrite = imgWrite(1:nS);
gatedContour = gatedContour(1:nS);
trackContour = trackContour(1:nS);

save(ffn_testImage, 'imgWrite', '*Contour');