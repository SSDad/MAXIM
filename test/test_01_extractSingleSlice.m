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

dataPath = 'X:\Lab\VR_VG_Pancreas_Ben\Cine\anamaria\18_one left\3799_pr003_error';
dataFileName = 'parsed_data_3799_pr003';


ffn_data = fullfile(dataPath, [dataFileName, '.mat']);
iS = 2778;
testImageFileName = [dataFileName, '_Slice_', num2str(iS)];

load(ffn_data)
imgWrite = imgWrite(iS);
gatedContour = gatedContour(iS);
trackContour = trackContour(iS);

save(testImageFileName, 'imgWrite', '*Contour');