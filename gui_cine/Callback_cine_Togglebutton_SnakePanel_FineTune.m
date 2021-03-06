function Callback_cine_Togglebutton_SnakePanel_FineTune(src, evnt)

global hFig_cine
global fhL
% contrastRectLim

data_cine = guidata(hFig_cine);
str = src.String;

hPlotObj = data_cine.Panel.View.Comp.hPlotObj;
hA = data_cine.Panel.View.Comp.hAxis.Image;

if strcmp(str, 'Fine Tune')
    src.String = 'Done';
    src.ForegroundColor = 'g';
    
    hPlotObj.Snake.Visible = 'off';
    
    xx = hPlotObj.Snake.XData;
    yy = hPlotObj.Snake.YData;
    fhL.Position = [xx' yy'];
    fhL.Visible = 'on';

    
% uistack(hA, 'top');

    axis(hA);
    
else % Done
    src.String = 'Fine Tune';
    src.ForegroundColor = 'c';
    
    sC =  fhL.Position;

    % sgolay
    framelen = round(size(sC, 1)/3);
    if mod(framelen, 2) == 0
        framelen = framelen+1;
    end
    framelen = min(framelen, 15);
    sC(:, 2) = sgolayfilt(sC(:, 2), 3, framelen);
    
    set(data_cine.Panel.View.Comp.hPlotObj.Snake, 'XData', sC(:, 1), 'YData', sC(:, 2));

    fhL.Visible = 'off';
    hPlotObj.Snake.Visible = 'on';

end
