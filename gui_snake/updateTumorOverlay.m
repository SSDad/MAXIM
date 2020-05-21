function updateTumorOverlay(data_main)

hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

% hPlotObj.Tumor.bwSum.Visible = 'on';
mask_GC = data_main.Tumor.mask_GC;
mask_TC = data_main.Tumor.mask_TC;

indSS = data_main.Tumor.indSS;

bwSum = sum(mask_GC(:,:,indSS), 3)+sum(mask_TC(:,:,indSS), 3);
hPlotObj.Tumor.bwSum.CData = bwSum;
hAxis.Tumor.CLim = [min(bwSum(:)) max(bwSum(:))];