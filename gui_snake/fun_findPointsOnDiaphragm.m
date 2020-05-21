function [xm, ym, xL, yL, xR, yR, yMean, xxn, yyn] = fun_findPointsOnDiaphragm(C, NP, dx)

% point x - mean over all contour x
xx = C(:, 2);
yy = C(:, 1);

% centroid
xm = mean(xx);
yMean = mean(yy);

%% lower half
ind = find(yy>yMean);
yyn = yy(ind);
xxn = xx(ind);

% mid. vert. line
xm = xm-mod(xm, dx);
x1 = [xm xm];
y1 = [yMean+10 1e4];

% cross
[xm, ym] = polyxpoly(x1, y1, xxn, yyn);

xL = xm-(1:NP)*dx;
xR = xm+(1:NP)*dx;
for n = 1:NP
    x1 = [xL(n) xL(n)];
    [~, yL(n)] = polyxpoly(x1, y1, xxn, yyn);

    x1 = [xR(n) xR(n)];
    [~, yR(n)] = polyxpoly(x1, y1, xxn, yyn);
end