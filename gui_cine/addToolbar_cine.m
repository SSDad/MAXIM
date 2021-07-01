function hToolbar = addToolbar_cine(hFig_cine)

%% toolbar          
hToolbar = uitoolbar ('parent', hFig_cine);

% standard
uitoolfactory(hToolbar,'Exploration.ZoomIn');
uitoolfactory(hToolbar,'Exploration.ZoomOut');
uitoolfactory(hToolbar,'Exploration.Pan');                
uitoolfactory(hToolbar,'Exploration.DataCursor');                
% uitoolfactory(hToolbar, 'Exploration.Rotate');