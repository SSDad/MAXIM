function Callback_Pushbutton_ButtonPanel_SaveMeasureData(src, evnt)

global hFig hFig2
data = guidata(hFig);
data2 = guidata(hFig2);

% csv point data
A = [data.Point.Data.xx data.Point.Data.yy data.Tumor.cent.y];
T = array2table(A, 'VariableNames',{'Slice #', 'Yt', 'Yd'});
writetable(T, data.FileInfo.ffn_PointData);

ffn_Data = data.FileInfo.ffn_measureData;
nF = 0;
if exist(ffn_Data, 'file')
    load(ffn_Data);
    nF = length(measureData);
end
measureData{nF+1} = data.MeasureData;
save(ffn_Data, 'measureData');

ffn_Fig = data.FileInfo.ffn_measureDataFig;
ffn_Fig = [ffn_Fig, '_', num2str(nF+1), '.jpg'];
%exportgraphics(hFig2, ffn_Fig, 'Resolution',300);
saveas(hFig2, ffn_Fig);

% ffn_Fig = [ffn_Fig, '_', num2str(nF+1)];
% print(hFig2, ffn_Fig, '-dpdf')