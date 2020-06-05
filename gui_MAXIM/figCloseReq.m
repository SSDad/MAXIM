function figCloseReq(src, callbackdata)
% Close all figures

data = guidata(src);
% if ishandle(data.Point.hFig)
%     delete(data.Point.hFig)
% end
delete(src)
%    selection = questdlg('Close This Figure?',...
%       'Close Request Function',...
%       'Yes','No','Yes'); 
%    switch selection 
%       case 'Yes'
%          delete(gcf)
%       case 'No'
%       return 
%    end
% end