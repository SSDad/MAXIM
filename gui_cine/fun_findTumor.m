function [sC] =  fun_findTumor(J, xyInfo, Rect, C)

% clear cC sC

bPlot = 0;

% convert to ij
C(:, 1) = (C(:, 1) - xyInfo.x0)/xyInfo.dx+1;
C(:, 2) = (C(:, 2) - xyInfo.y0)/xyInfo.dy+1;

Rect(1) = (Rect(1) - xyInfo.x0)/xyInfo.dx+1;
Rect(3) = (Rect(3) - xyInfo.x0)/xyInfo.dx+1;
Rect(2) = (Rect(2) - xyInfo.y0)/xyInfo.dy+1;
Rect(4) = (Rect(4) - xyInfo.y0)/xyInfo.dy+1;

%  crop
JC = imcrop(J, Rect);
cC(:, 1) = C(:, 1)-Rect(1);
cC(:, 2) = C(:, 2)-Rect(2);

framelen = round(size(cC, 1)/4);
if mod(framelen, 2) == 0
    framelen = framelen+1;
end
framelen = min(framelen, 25);
cC(:, 2) = sgolayfilt(cC(:, 2), 3, framelen);

if bPlot
    figure(101), clf
    imshow(J, []); hold on
    rectangle('Position', Rect, 'EdgeColor', 'c');
    line('XData', C(:, 1), 'YData', C(:, 2), 'Color', 'g');

    figure(102), clf
    imshow(JC, []); hold on
    line('XData', cC(:, 1), 'YData', cC(:, 2), 'Color', 'r');
end

[mJC, nJC] = size(JC);
% if cC(1, 1) < cC(end, 1)
%     yy1 = ceil(cC(end, 2)):mJC;
%     yy1 = yy1';
%     xx1 = repmat(nJC, length(yy1), 1);
%     
%     xx2 = nJC-1:-1:2;
%     xx2 = xx2';
%     yy2 = repmat(mJC, length(xx2), 1);
%     
%     yy3 = mJC:-1:ceil(cC(1, 2));
%     yy3 = yy3';
%     xx3 = ones(length(yy3), 1);
% else
% end
% sC(:,1) = [cC(:, 1); xx1; xx2; xx3];
% sC(:,2) = [cC(:, 2); yy1; yy2; yy3];

% if bPlot
%     figure(102)
%     line('XData', sC(:, 1), 'YData', sC(:, 2), 'Color', 'g', 'LineWidth', 2);
% end    
% mask = poly2mask(sC(:, 1), sC(:, 2), mJC, nJC);

mask = poly2mask(cC(:, 1), cC(:, 2), mJC, nJC);
bw = activecontour(JC, mask, 5, 'Chan-Vese', 'SmoothFactor', 2, 'ContractionBias', -0.2);

%% contour
B = bwboundaries(bw);

nP = zeros(length(B), 1);
for m = 1:length(B)
    nP(m) = size(B{m}, 1);
end
[~, idx] = max(nP);
sC = fliplr(B{idx});

% if bPlot
%     figure(102)
%     line('XData', sC(:, 1), 'YData', sC(:, 2), 'Color', 'r', 'LineWidth', 2);
% end    

% de-crop
sC(:, 1) = sC(:, 1)+Rect(1);
sC(:, 2) = sC(:, 2)+Rect(2);

% sgolay
framelen = round(size(sC, 1)/3);
if mod(framelen, 2) == 0
    framelen = framelen+1;
end
framelen = min(framelen, 15);
sC(:, 2) = sgolayfilt(sC(:, 2), 3, framelen);


% % cut (side first)
% % cent = mean(sC);
% xCut = 10;
% x1 = min(sC(:, 1));
% x2 = max(sC(:, 1));
% ind = find(sC(:, 1) > x1+xCut);
% sC = sC(ind, :);
% ind = find(sC(:, 1) < x2-xCut);
% sC = sC(ind, :);
% 
% dind = diff(ind);
% [~, idx] = max(dind);
% junk1 = sC(1:idx, :);
% junk2 = sC(idx:end, :);
% 
% if mean(junk1(:, 2)) > mean(junk2(:, 2))
%     sC = junk2;
% else
%     sC = junk1;
% end
 
if bPlot
    figure(101)
    line('XData', sC(:, 1), 'YData', sC(:, 2), 'Color', 'r', 'LineWidth', 2);
end    

% back to xy
sC(:, 1) = (sC(:, 1)-1)*xyInfo.dx + xyInfo.x0;
sC(:, 2) = (sC(:, 2)-1)*xyInfo.dy + xyInfo.y0;



