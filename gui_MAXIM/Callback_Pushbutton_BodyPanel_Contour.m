function Callback_Pushbutton_BodyPanel_Contour(src, evnt)

hFig = ancestor(src, 'Figure');
data = guidata(hFig);

x0 = data.Image.x0;
y0 = data.Image.y0;
dx = data.Image.dx;
dy = data.Image.dy;

II = data.Image.Images;

nSlices = data.Image.nSlices;
hBody = data.Panel.View.Comp.hPlotObj.Body;
hAb = data.Panel.View.Comp.hPlotObj.Ab;
hSnake = data.Panel.View.Comp.hPlotObj.Snake;

for iSlice = 1:nSlices
    bC = []; % body Contour
    abC2 = []; % abdomen Contour
    if data.Tumor.bInd_GC(iSlice) || data.Tumor.bInd_TC(iSlice) % gating or tracking contour on image
    
        J = rot90(rgb2gray(II{iSlice}), 3);
        [mJ, nJ] = size(J);

        BW = im2bw(J, 0.2);
        BW2 = imfill(BW, 'holes');
        BW3 = bwconvhull(BW2);
        bd = bwboundaries(BW3);

        idx = 1;
        if length(bd) > 1
            for n = 1:length(bd)
                nP(n) = size(bd{n}, 1);
            end
            [~, idx] = max(nP);
        end
        bC = bd{idx};
        data.Body.Contours{iSlice} = bC; % 1 - row, 2 - column
        
        % ab
        % lower than left end of diaphram and on left of diaphram
        sC = data.Snake.Snakes{iSlice}; % diaphragm Contour, 1 - column, 2 - row
        [n1, idx] = min(sC(:, 1));
        m1 = sC(idx, 2);
        m2 = size(J, 1);
        
        ind1 = bC(:, 1) > m1 & bC(:, 1) < m2 - 10;
        abC1 = bC(ind1, :);
        
        ind2 =  abC1(:, 2) < n1;
        abC2 = abC1(ind2, :);
        
        [~, idx] = min(abC2(:, 1));
        abC2 = circshift(abC2, -idx, 1);
        
        [~, idx] = min(abC2(:,1));
        if idx > 5
            abC2 = flip(abC2);
        end
        data.Body.Abs{iSlice} = abC2; % 1 - row, 2 - column

    end
    
    % update slice iamge
    data.Panel.View.Comp.hPlotObj.Image.CData = rot90(data.Image.Images{iSlice}, 3);
    if isempty(bC)
        hBody.YData = [];
        hBody.XData = [];
        hAb.YData = [];
        hAb.XData = [];
        hSnake.YData = [];
        hSnake.XData = [];
    else
        hBody.YData = (bC(:, 1)-1)*dy+y0;
        hBody.XData = (bC(:, 2)-1)*dx+x0;
        hAb.YData = (abC2(:, 1)-1)*dy+y0;
        hAb.XData = (abC2(:, 2)-1)*dx+x0;
        hSnake.YData = (sC(:, 2)-1)*dy+y0;
        hSnake.XData = (sC(:, 1)-1)*dx+x0;
    end
    data.Panel.SliceSlider.Comp.hSlider.Slice.Value = iSlice;
    data.Panel.SliceSlider.Comp.hText.nImages.String = [num2str(iSlice), ' / ', num2str(nSlices)];
        
    pause(0.1);
end

data.Body.ContourDone = 1;

guidata(hFig, data)
