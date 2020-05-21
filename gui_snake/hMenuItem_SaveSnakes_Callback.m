function hMenuItem_SaveSnakes_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

ffn_snakes = data_main.ffn_snakes;

snakes = data_main.cont;

save(ffn_snakes, 'snakes');