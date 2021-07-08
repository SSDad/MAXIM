function [posRect] = fun_surroundingRect(C, BR, orig, imgSize)
    
xx = C(:, 1);
yy = C(:, 2);
x0 = orig(1);
y0 = orig(2);

x1 = min(xx); x2 = max(xx); xL = (x2-x1)*BR;
y1 = min(yy); y2 = max(yy); yL = (y2-y1)*BR;
xyL = min(xL, yL);
xR1 = max(x1 - xyL, x0);
xR2 = min(x2 + xyL, x0 + imgSize(1));
yR1 = max(y1 - xyL, y0);
yR2 = min(y2 + xyL, y0 +imgSize(2));
posRect = [xR1 yR1 xR2-xR1 yR2-yR1];
