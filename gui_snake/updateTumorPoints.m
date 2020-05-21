function updateTumorPoints(data_main)

hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;

ixm = data_main.Point.ixm;
xi = data_main.Point.xi;
yi = data_main.Point.yi;
NP = data_main.Point.NP;

yy = mean(yi(:, ixm-NP:ixm+NP), 2);

indSS = data_main.Tumor.indSS;

for n = 1:data_main.nImages
    hPlotObj.Tumor.Points(n).XData = [];
    hPlotObj.Tumor.Points(n).YData = [];
end

for n = 1:length(indSS)
    hPlotObj.Tumor.Points(n).XData = xi(ixm);
    hPlotObj.Tumor.Points(n).YData = yy(indSS(n));
end