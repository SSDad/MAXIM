function Comp = addComponents2Panel_cine_SliceSlider(hPanel)

Comp.hSlider.Slice = uicontrol('Parent',  hPanel,...
            'Style','slider',...
            'Units', 'normalized',...
            'Position',[0.2 0.1 0.6 0.8],...
            'BackgroundColor', 'b',...
            'ForegroundColor', 'w',...
            'Visible', 'on', ...
                'Callback', @Callback_cine_Slider_SliceSliderPanel_SliceSlider);
            
Comp.hText.nImages = uicontrol('Parent', hPanel, ...
                                'Style', 'text', ...
                                'Units',                     'normalized', ...
                                'Position', [0. 0.025 1 0.05], ...
                                'FontSize', 12, ...
                                'FontWeight', 'bold', ...
                                'BackgroundColor', 'b',...
                                'ForegroundColor', 'w',...
                                'Visible', 'on', ...
                                'String', 'iSlice / nSlices');