function [xLP, yLP, xRP, yRP] = fun_findNeighbourPoints(xx, yy, ip, NP)

idx = ip;
for n = 1:NP
    if idx > 1
        idx = idx-1; 
    else
        idx = length(xx);
    end
    xLP(n) = xx(idx);
    yLP(n) = yy(idx);
        
    if idx < length(xx)
        idx = idx+1; 
    else
        idx = 1;
    end
    xRP(n) = xx(idx);
    yRP(n) = yy(idx);
end