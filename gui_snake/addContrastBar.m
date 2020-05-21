function [hAxis, hHist, hRect] = addContrastBar(parent)

hAxis = axes('Parent',        parent, ...
                    'color',        'none',...
                    'Units',       'normalized', ...
                    'Position',    [0. 0. 1. 1.]);
hold(hAxis, 'on');

hHist = [];
hRect = [];