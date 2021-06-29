clearvars

path_mri = 'X:\Zhen\CineMRI';
path_dcm = fullfile(path_mri, 'CineDicom');

dcmC = dicomCollection(path_dcm);

save('dcmInfo', 'dcmC', 'path*')