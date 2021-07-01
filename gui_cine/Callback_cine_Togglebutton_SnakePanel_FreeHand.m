function Callback_cine_Togglebutton_SnakePanel_FreeHand(src, evnt)

global hFig_cine
global fhL
% contrastRectLim

data_cine = guidata(hFig_cine);
str = src.String;

if strcmp(str, 'Free Hand')
    src.String = 'Done';
    src.ForegroundColor = 'g';
    
    hA = data_cine.Panel.View.Comp.hAxis.Image;
% uistack(hA, 'top');

    axis(hA);
    fhL = images.roi.AssistedFreehand(hA, 'Image', data_cine.Panel.View.Comp.hPlotObj.Image);

    draw(fhL);
    
else % Done
    src.String = 'Free Hand';
    src.ForegroundColor = 'c';
    
    xx =  fhL.Position(:, 1);
    yy =  fhL.Position(:, 2);
    set(data_cine.Panel.View.Comp.hPlotObj.Snake, 'XData', xx, 'YData', yy);

    fhL.Visible = 'off';
    
    % snake box
    x1 = min(xx); x2 = max(xx); xL = x2-x1;
    y1 = min(yy); y2 = max(yy); yL = y2-y1;
    xyL = min(xL, yL);
    xR1 = max(x1 - xyL, data_cine.Image.x0);
    xR2 = min(x2 + xyL, data_cine.Image.x0 + data_cine.Image.RA.ImageExtentInWorldX);
    yR1 = max(y1 - xyL, data_cine.Image.y0);
    yR2 = min(y2 + xyL, data_cine.Image.y0 + data_cine.Image.RA.ImageExtentInWorldY);
    posSnakeRect = [xR1 yR1 xR2-xR1 yR2-yR1];
    set(data_cine.Panel.View.Comp.hPlotObj.SnakeRect, 'Position', posSnakeRect, 'Visible', 'on');
    
    % template match box
    x1 = min(xx); x2 = max(xx); xL = (x2-x1)*2;
    y1 = min(yy); y2 = max(yy); yL = (y2-y1)*2;
    xyL = min(xL, yL);
    xR1 = max(x1 - xyL, data_cine.Image.x0);
    xR2 = min(x2 + xyL, data_cine.Image.x0 + data_cine.Image.RA.ImageExtentInWorldX);
    yR1 = max(y1 - xyL, data_cine.Image.y0);
    yR2 = min(y2 + xyL, data_cine.Image.y0 + data_cine.Image.RA.ImageExtentInWorldY);
    posTMRect = [xR1 yR1 xR2-xR1 yR2-yR1];
    set(data_cine.Panel.View.Comp.hPlotObj.TMRect, 'Position', posTMRect, 'Visible', 'on');
    
    xyInfo.x0 = data_cine.Image.x0;
    xyInfo.y0 = data_cine.Image.y0;
    xyInfo.dx = data_cine.Image.dx;
    xyInfo.dy = data_cine.Image.dy;
    J = data_cine.Panel.View.Comp.hPlotObj.Image.CData;
    
    C =  [xx yy];
    [sC] =  fun_findTumor(J, xyInfo, posSnakeRect, C);

    set(data_cine.Panel.View.Comp.hPlotObj.Snake, 'XData', sC(:, 1), 'YData', sC(:, 2));

end



% %% slice No.
% startSlice = str2double(data.Panel.Snake.Comp.Edit.StartSlice.String);
% endSlice = str2double(data.Panel.Snake.Comp.Edit.EndSlice.String);
% 
% hSlider = data.Panel.SliceSlider.Comp.hSlider.Slice;
% iSlice = round(hSlider.Value);
% 
% if iSlice < startSlice | iSlice > endSlice
%     iSlice = startSlice;
%     hSlider.Value = iSlice;
%     data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(data.Image.nImages)];
% 
%     % image
%     I = rot90(data.Image.Images{iSlice}, 3);
% 
%     % contrast limit
%     maxI = max(I(:));
%     minI = min(I(:));
%     wI = maxI-minI;
%     cL1 = minI+wI*contrastRectLim(1);
%     cL2 = minI+wI*contrastRectLim(2);
%     I(I<cL1) = cL1;
%     I(I>cL2) = cL2;
% 
%     hPlotObj = data.Panel.View.Comp.hPlotObj;
%     hPlotObj.Image.CData = I;
% end
% 
% % remove snake
% hPlotObj = data.Panel.View.Comp.hPlotObj;
% hPlotObj.Snake.YData = [];
% hPlotObj.Snake.XData = [];
% 
% %%%%%%%%%%%%%%%%%
% if data.Point.InitDone
%     data.Point.Data.yi(iSlice, :) = NaN;
%     
%     hPlotObj.Point.XData = [];
%     hPlotObj.Point.YData = [];
%     hPlotObj.LeftPoints.XData = [];
%     hPlotObj.LeftPoints.YData = [];
%     hPlotObj.RightPoints.XData = [];
%     hPlotObj.RightPoints.YData = [];
% 
%     guidata(hFig, data)
%     updatePlotPoint
% end
% %%%%%%%%%%%%%%%%%
% 
% 
% data.Snake.FreeHand.L = L;
% data.Snake.FreeHand.Done = true;
% 
% data.Panel.Snake.Comp.Togglebutton.Slither.Enable = 'on';
% data.Panel.Snake.Comp.Togglebutton.Slither.ForegroundColor = 'g';
% 
% %% save
% guidata(hFig, data);                