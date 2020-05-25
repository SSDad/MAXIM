function [sC] =  fun_findDiaphragm(J, Rect, C)

% clear cC sC

JC = imcrop(J, Rect);
cC(:, 1) = C(:, 1)-Rect(1);
cC(:, 2) = C(:, 2)-Rect(2);
cC(:, 2) = sgolayfilt(cC(:, 2), 3, 75);

% figure
% imshow(JC); hold on
% line('XData', cC(:, 1), 'YData', cC(:, 2), 'Color', 'c');

[mJC, nJC] = size(JC);
if cC(1, 1) < cC(end, 1)
    yy1 = ceil(cC(end, 2)):mJC;
    yy1 = yy1';
    xx1 = repmat(nJC, length(yy1), 1);
    
    xx2 = nJC-1:-1:2;
    xx2 = xx2';
    yy2 = repmat(mJC, length(xx2), 1);
    
    yy3 = mJC:-1:ceil(cC(1, 2));
    yy3 = yy3';
    xx3 = ones(length(yy3), 1);
else
end
sC(:,1) = [cC(:, 1); xx1; xx2; xx3];
sC(:,2) = [cC(:, 2); yy1; yy2; yy3];

mask = poly2mask(sC(:, 1), sC(:, 2), mJC, nJC);
bw = activecontour(JC, mask, 50, 'Chan-Vese', 'SmoothFactor', 2);

%% contour
B = bwboundaries(bw);

nP = zeros(length(B), 1);
for m = 1:length(B)
    nP(m) = size(B{m}, 1);
end
[~, idx] = max(nP);

sC = fliplr(B{idx});

sC(:, 1) = sC(:, 1)+Rect(1);
sC(:, 2) = sC(:, 2)+Rect(2);

% cut (side first)
% cent = mean(sC);
xCut = 10;
x1 = min(sC(:, 1));
x2 = max(sC(:, 1));
ind = find(sC(:, 1) > x1+xCut);
sC = sC(ind, :);
ind = find(sC(:, 1) < x2-xCut);
sC = sC(ind, :);

dind = diff(ind);
[~, idx] = max(dind);
junk1 = sC(1:idx, :);
junk2 = sC(idx:end, :);

if mean(junk1(:, 2)) > mean(junk2(:, 2))
    sC = junk2;
else
    sC = junk1;
end
% smooth
% sC(:, 1) = sgolayfilt(sC(:, 1), 3, 75);
sC(:, 2) = sgolayfilt(sC(:, 2), 3, 75);




