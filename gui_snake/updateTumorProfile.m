function updateTumorProfile(data_main)

hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;
hPL = hPlotObj.Profile.PL;

bwSum = hPlotObj.Tumor.bwSum.CData;
pos = hPL.Position; 

xL = data_main.RA.XWorldLimits;
yL = data_main.RA.YWorldLimits;
[xProf, yProf, prof] = improfile(xL, yL, bwSum, pos(:, 1), pos(:, 2));

rr = ((xProf-xProf(1)).^2+(yProf-yProf(1)).^2).^0.5;

% line
hPlotObj.Profile.Profile.XData = rr;
hPlotObj.Profile.Profile.YData = prof;

% patches
maxV = max(prof);

xL2 = find(prof == maxV, 1, 'first');
if prof(1) == 0
    xL1 = find(prof(1:xL2) == 0, 1, 'last');
else
    xL1 = 1;
end
hPlotObj.Profile.Patch1.XData = [rr(xL1) rr(xL2) rr(xL2) rr(xL1)];
hPlotObj.Profile.Patch1.YData = [0 0 maxV maxV];
hPlotObj.Profile.Text1.Position = [rr(xL1)+2*data_main.dx maxV 0];
hPlotObj.Profile.Text1.String = num2str(rr(xL2)-rr(xL1), '%4.1f');

xR1 = find(prof == maxV, 1, 'last');
if prof(end) == 0
    junk = find(prof(xR1:end) == 0, 1, 'first');
    xR2 = junk+xR1-1;
else
    xR2 = length(prof);
end

hPlotObj.Profile.Patch2.XData = [rr(xR1) rr(xR2) rr(xR2) rr(xR1)];
hPlotObj.Profile.Patch2.YData = [0 0 maxV maxV];
hPlotObj.Profile.Text2.Position = [rr(xR2)-4*data_main.dx maxV 0];
hPlotObj.Profile.Text2.String = num2str(rr(xR2)-rr(xR1), '%4.1f');

% ref contour
RC = data_main.Tumor.RC_TC{1};
[xi, yi] = polyxpoly(pos(:, 1), pos(:, 2), RC(:, 1), RC(:, 2));

xr = ((xi-xProf(1)).^2+(yi-yProf(1)).^2).^0.5;
xr = sort(xr);

hPlotObj.Profile.RefLeft.XData = [xr(1) xr(1)];
hPlotObj.Profile.RefLeft.YData = [0 maxV];

hPlotObj.Profile.RefRight.XData = [xr(2) xr(2)];
hPlotObj.Profile.RefRight.YData = [0 maxV];

hPlotObj.Profile.RefTextLeft1.Position = [rr(xL1) maxV/2 0];
hPlotObj.Profile.RefTextLeft1.String = num2str(abs(xr(1)-rr(xL1)), '%4.1f');
hPlotObj.Profile.RefTextLeft1.HorizontalAlignment = 'right';
hPlotObj.Profile.RefTextLeft2.Position = [rr(xL2) maxV/2 0];
hPlotObj.Profile.RefTextLeft2.String = num2str(abs(xr(1)-rr(xL2)), '%4.1f');
hPlotObj.Profile.RefTextLeft2.HorizontalAlignment = 'left';

hPlotObj.Profile.RefTextRight1.Position = [rr(xR1) maxV/2 0];
hPlotObj.Profile.RefTextRight1.String = num2str(abs(xr(2)-rr(xR1)), '%4.1f');
hPlotObj.Profile.RefTextRight1.HorizontalAlignment = 'right';
hPlotObj.Profile.RefTextRight2.Position = [rr(xR2) maxV/2 0];
hPlotObj.Profile.RefTextRight2.String = num2str(abs(xr(2)-rr(xR2)), '%4.1f');
hPlotObj.Profile.RefTextRight2.HorizontalAlignment = 'left';

