function initTumorOverlay(hFig_main)

data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;
hSlider = data_main.hSlider;

dataPath = data_main.dataPath;
matFile = data_main.matFile;

[~, fn1, ~] = fileparts(matFile);
ffn = fullfile(dataPath, [fn1, '_Tumor.mat']);

if exist(ffn, 'file')
    load(ffn)
else
    [M, N, ~] = size(data_main.hPlotObj.snakeImage.CData);
    contGC = data_main.gatedContour;
    [bwCAll_GC, mask_GC, bwSum_GC, polyA_GC, CC_GC] = fun_getCC(contGC, M, N);

    contTC = data_main.trackContour;
    [bwCAll_TC, mask_TC, bwSum_TC, polyA_TC, CC_TC] = fun_getCC(contTC, M, N);

    nImages = length(contGC);
    save(ffn, 'bwSum_*', 'mask_*', 'polyA_*', 'CC_*', 'M', 'N', 'nImages');
end

% Tumor plot
hPlotObj.Tumor.bwSum.Visible = 'on';

bwSum = sum(mask_GC, 3)+sum(mask_TC, 3);
hPlotObj.Tumor.bwSum.CData = bwSum;
hAxis.Tumor.CLim = [min(bwSum(:)) max(bwSum(:))];

data_main.Tumor.mask_GC = mask_GC;
data_main.Tumor.mask_TC = mask_TC;
data_main.Tumor.CC_GC = CC_GC;
data_main.Tumor.CC_TC = CC_TC;

linkaxes([hAxis.snake hAxis.Tumor]);

data_main.hMenuItem.Tumor.bwSum.Checked = 'on';

guidata(hFig_main, data_main)