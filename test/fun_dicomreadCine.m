function [data] = fun_dicomreadCine(bSag, bCor, dcmFileNames)

nFile = length(dcmFileNames);

if bSag && bCor % Sag+Cor
    sag = [];
    cor = [];
    acqt_sag = [];
    acqt_cor = [];
    hWB = waitbar(0);
    for n = 1:nFile
        di = dicominfo(dcmFileNames(n));
        iop = di.ImageOrientationPatient;
        I = dicomread(dcmFileNames(n));
        
        if iop == [0 1 0 0 0 -1]'  % sag
            sag =  cat(3, sag, I);
            acqt_sag = [acqt_sag; str2double(di.AcquisitionTime)];
        elseif iop == [1 0 0 0 0 -1]'  % cor
            cor =  cat(3, cor, I);
            acqt_cor = [acqt_cor; str2double(di.AcquisitionTime)];
        end
        
        waitbar(n/nFile, hWB, ['Processing ', num2str(n), '/', num2str(nFile)])
    end
    close(hWB);
    
    [~, ind] = sort(acqt_sag);
    data.sag = sag(:,:,ind);

    [~, ind] = sort(acqt_cor);
    data.cor = cor(:,:,ind);
    
    data.sc = 'sc';
    
elseif (bSag && ~bCor) |  (~bSag && bCor) % Sag
    v = [];
    acqt = [];
    hWB = waitbar(0);
    for n = 1:nFile
        I = dicomread(dcmFileNames(n));
        v = cat(3, v, I);
        junk = dicominfo(dicomFileName(n));
        acqt = [acqt; str2double(di.AcquisitionTime)];
        waitbar(n/nFile, hWB, ['Processing ', num2str(n), '/', num2str(nFile)])
    end
    close(hWB);
    
    [~, ind] = sort(acqt);
    data.v = v(:,:,ind);
    
    data.sc = 'sag';
    if bCor
        data.sc = 'cor';
    end
    
end
