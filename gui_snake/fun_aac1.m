function [SC] = fun_aac(I, MC, snakeParam)

[M, N] = size(I);
    
    mask = poly2mask(MC(:,1), MC(:,2), M, N);
    nIter = snakeParam.nIter;
    smoothFactor = snakeParam.smoothFactor;
    contractionBias = snakeParam.contractionBias;
    
    bw = activecontour(I, mask, nIter, 'Chan-Vese',...
        'SmoothFactor', smoothFactor, 'ContractionBias', contractionBias);
    B = bwboundaries(bw);
    
    nP = zeros(length(B), 1);
    for m = 1:length(B)
        nP(m) = size(B{m}, 1);
    end
    [~, idx] = max(nP);

    SC = fliplr(B{idx});