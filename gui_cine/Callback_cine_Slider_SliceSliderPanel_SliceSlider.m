function Callback_cine_Slider_SliceSliderPanel_SliceSlider(src, evnt)

global hFig_cine contrastRectLim_cine
global bFreeHand fhSlice

data_cine = guidata(hFig_cine);

% startSlice = str2double(data_cine.Panel.Snake.Comp.Edit.StartSlice.String);
% endSlice = str2double(data_cine.Panel.Snake.Comp.Edit.EndSlice.String);

iSlice = round(get(src, 'Value'));

% Tumor = data.Tumor;
% CLR = 'rgb';
I = data_cine.Image.Images(:,:,iSlice);

% contrast limit
maxI = max(I(:));
minI = min(I(:));
wI = maxI-minI;
cL1 = minI+wI*contrastRectLim_cine(1);
cL2 = minI+wI*contrastRectLim_cine(2);
I(I<cL1) = cL1;
I(I>cL2) = cL2;

hPlotObj = data_cine.Panel.View.Comp.hPlotObj;
hPlotObj.Image.CData = I;

% %tumor center
% data.Panel.View.Comp.hPlotObj.TumorCent.XData = data.Tumor.cent.x(iSlice);
% data.Panel.View.Comp.hPlotObj.TumorCent.YData = data.Tumor.cent.y(iSlice);

data_cine.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(data_cine.Image.nSlices)];

% hist
yc = histcounts(I, max(I(:))+1);
yc = log10(yc);
yc = yc/max(yc);
xc = 1:length(yc);
xc = xc/max(xc);
data_cine.Panel.ContrastBar.Comp.Panel.Constrast.hPlotObj.Hist.XData = xc;
data_cine.Panel.ContrastBar.Comp.Panel.Constrast.hPlotObj.Hist.YData = yc;

% free hand
data_cine.Panel.View.Comp.hPlotObj.Snake.Visible = 'off';

if isfield(data_cine, 'Snake')
    if iSlice <= numel(data_cine.Snake)
        if ~isempty(data_cine.Snake(iSlice).sC)
            data_cine.Panel.View.Comp.hPlotObj.Snake.Visible = 'on';
        end
    end
end

% % snake
% x0 = data.Image.x0;
% y0 = data.Image.y0;
% dx = data.Image.dx;
% dy = data.Image.dy;
% 
% if data.Snake.SlitherDone
%     CB = data.Snake.Snakes{iSlice};
%     if isempty(CB)
%         data.Panel.View.Comp.hPlotObj.Snake.XData = [];
%         data.Panel.View.Comp.hPlotObj.Snake.YData = [];
%     else
%         data.Panel.View.Comp.hPlotObj.Snake.YData = (CB(:, 2)-1)*dy+y0;
%         data.Panel.View.Comp.hPlotObj.Snake.XData = (CB(:, 1)-1)*dx+x0;
%     end
% 
% %     CM =  data_main.maskCont{sV};
% %     if isempty(CM)
% %         data_main.hPlotObj.maskCont.XData = [];
% %         data_main.hPlotObj.maskCont.YData = [];
% %     else
% %         data_main.hPlotObj.maskCont.YData = (CM(:, 2)-1)*dy+y0;
% %         data_main.hPlotObj.maskCont.XData = (CM(:, 1)-1)*dx+x0;
% %     end
% 
%     if data.Point.InitDone
%         % points on contour
%         xi = data.Point.Data.xi;
%         yi = data.Point.Data.yi;
%         ixm = data.Point.Data.ixm;
%         NP = data.Point.Data.NP;
% 
%         hPlotObj = data.Panel.View.Comp.hPlotObj;
%         hPlotObj.Point.XData = xi(ixm);
%         hPlotObj.Point.YData = yi(iSlice, ixm);
%         hPlotObj.LeftPoints.XData = xi(ixm-NP:ixm-1);
%         hPlotObj.LeftPoints.YData = yi(iSlice, ixm-NP:ixm-1);
%         hPlotObj.RightPoints.XData = xi(ixm+1:ixm+NP);
%         hPlotObj.RightPoints.YData = yi(iSlice, ixm+1:ixm+NP);
% 
%         % point of current slice on points plot
%         data2 = guidata(hFig2);
%         data2.Panel.View.Comp.hPlotObj.PlotPoint.Current.XData = iSlice;
%         data2.Panel.View.Comp.hPlotObj.PlotPoint.Current.YData = mean(yi(iSlice, ixm-NP:ixm+NP));
%     end
% 
% end
% 
% % if data.Body.ContourDone
% if data.Panel.Selection.Comp.Radiobutton.Body.Value    
%     bC = data.Body.Contours{iSlice};
%     abC2 = data.Body.AbsContours{iSlice};
%     hPlotObj = data.Panel.View.Comp.hPlotObj;
% %     if data.Body.ContourDone 
%         if isempty(abC2)
%             hPlotObj.Body.XData = [];
%             hPlotObj.Body.YData = [];
%             hPlotObj.Ab.XData = [];
%             hPlotObj.Ab.YData = [];
%         else
% %             hPlotObj.Body.YData = (bC(:, 1)-1)*dy+y0;
% %             hPlotObj.Body.XData = (bC(:, 2)-1)*dx+x0;
%             hPlotObj.Ab.YData = (abC2(:, 1)-1)*dy+y0;
%             hPlotObj.Ab.XData = (abC2(:, 2)-1)*dx+x0;
%         end
% %     end
% end
% 
% data.Point.Data.iSlice = iSlice;
% 
% 
% guidata(hFig, data);
% 
% % 
% % 
% 
% % 
% % if data_main.LineDone
% %     
% % 
