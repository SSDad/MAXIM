function [mask_GC, mask_TC, CC_GC, CC_TC, CC_RC] = getTumorcontour(hFig_main)

data_main = guidata(hFig_main);

dataPath = data_main.dataPath;
matFile = data_main.matFile;

[~, fn1, ~] = fileparts(matFile);
ffn = fullfile(dataPath, [fn1, '_Tumor.mat']);

if exist(ffn, 'file')
    load(ffn)
    if ~exist('CC_RC', 'var')
        [M, N, ~] = size(data_main.hPlotObj.snakeImage.CData);
        contRC = data_main.refContour;
        iP = round(size(contRC, 1)/2);
        [Xout, Yout]=fun_points2contour(contRC(:, 1), contRC(:,2), iP, 'ccw');
        CC_RC{1} = [N-Yout'+1 Xout'];
    
        % save as 1x1 pixel size
        nImages = length(contGC);
        save(ffn, 'bwSum_*', 'mask_*', 'polyA_*', 'CC_*', 'M', 'N', 'nImages');
    end    
    
else
    [M, N, ~] = size(data_main.hPlotObj.snakeImage.CData);
    contGC = data_main.gatedContour;
    [bwCAll_GC, mask_GC, bwSum_GC, polyA_GC, CC_GC] = fun_getCC(contGC, M, N);

    contTC = data_main.trackContour;
    [bwCAll_TC, mask_TC, bwSum_TC, polyA_TC, CC_TC] = fun_getCC(contTC, M, N);

    contRC = data_main.refContour;
    iP = round(size(contRC, 1)/2);
    [Xout, Yout]=fun_points2contour(contRC(:, 1), contRC(:,2), iP, 'ccw');
    CC_RC{1} = [N-Yout'+1 Xout'];
    
    % save as 1x1 pixel size
    nImages = length(contGC);
    save(ffn, 'bwSum_*', 'mask_*', 'polyA_*', 'CC_*', 'M', 'N', 'nImages');
end

for n = 1:length(CC_GC)
    if ~isempty(CC_GC{n})
        CC_GC{n}(:, 1) = (CC_GC{n}(:, 1)-1)*data_main.dx+data_main.x0;
        CC_GC{n}(:, 2) = (CC_GC{n}(:, 2)-1)*data_main.dy+data_main.y0;
    end
    if ~isempty(CC_TC{n})
        CC_TC{n}(:, 1) = (CC_TC{n}(:, 1)-1)*data_main.dx+data_main.x0;
        CC_TC{n}(:, 2) = (CC_TC{n}(:, 2)-1)*data_main.dy+data_main.y0;
    end
end

n = 1;
if ~isempty(CC_RC{n})
        CC_RC{n}(:, 1) = (CC_RC{n}(:, 1)-1)*data_main.dx+data_main.x0;
        CC_RC{n}(:, 2) = (CC_RC{n}(:, 2)-1)*data_main.dy+data_main.y0;
 end
    


% data_main.Tumor.mask_GC = mask_GC;
% data_main.Tumor.mask_TC = mask_TC;
% data_main.Tumor.CC_GC = CC_GC;
% data_main.Tumor.CC_TC = CC_TC;
% 
% guidata(hFig_main, data_main)