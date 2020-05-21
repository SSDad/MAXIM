function [SC, diffArea1, diffXOR1, diffArea, diffXOR] = fun_aac(I, MC, snakeParam, MC1, mask1)

method = 'Chan-Vese';
% method = 'edge';

[M, N] = size(I);
    
mask = poly2mask(MC(:,1), MC(:,2), M, N);
nIter = snakeParam.nIter;
smoothFactor = snakeParam.smoothFactor;
contractionBias = snakeParam.contractionBias;

diffXOR1= 1;
iW = 0;
while abs(diffXOR1) > 0.15

    bw = activecontour(I, mask, nIter, method,...
        'SmoothFactor', smoothFactor, 'ContractionBias', contractionBias);
    B = bwboundaries(bw);
    
    nP = zeros(length(B), 1);
    for m = 1:length(B)
        nP(m) = size(B{m}, 1);
    end
    [~, idx] = max(nP);

    SC = fliplr(B{idx});
    
    % diff
    aSC = polyarea(SC(:,1), SC(:,2));
    aMC1 = polyarea(MC1(:,1), MC1(:,2));
    diffArea1 = (aSC-aMC1)/aMC1;
    aMC = polyarea(MC(:,1), MC(:,2));
    diffArea = (aSC-aMC)/aMC;
    
    maskSC = poly2mask(SC(:,1), SC(:,2), M, N);
    maskMC1 = poly2mask(MC1(:,1), MC1(:,2), M, N);
    maskXOR1 = xor(maskSC, maskMC1);    
    diffXOR1 = sum(maskXOR1(:))/sum(maskMC1(:));
    maskXOR = xor(maskSC, mask);    
    diffXOR = sum(maskXOR(:))/sum(mask(:));
    
    iW = iW+1;
    contractionBias = -diffArea/abs(diffArea)*iW/10;
    
    if iW > 4
        mask = mask1;
    end
    
    if iW > 10
        break
    end
end
