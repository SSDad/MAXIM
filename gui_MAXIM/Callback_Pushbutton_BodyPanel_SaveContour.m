function Callback_Pushbutton_BodyPanel_SaveContour(src, evnt)

global hFig

data = guidata(hFig);

AbsContour = data.Body.AbsContour;
ffn_AbsContour = data.FileInfo.ffn_AbsContour;
save(ffn_AbsContour, 'AbsContour');