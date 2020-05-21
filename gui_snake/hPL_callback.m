function hPL_callback(src, evnt)
hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
    
updateTumorProfile(data_main) 