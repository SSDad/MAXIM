clearvars
load('junk')
% refC = data_main.refContour;

hF = figure(99); clf
hA1 =axes('parent', hF);

hI = imshow(J, [], 'parent', hA1);
axis on
% convert to ij
xx = FC(:,1)/dx+1;
yy = FC(:,2)/dy+1;

line(hA1, xx, yy, 'Color', 'g')


[M, N] = size(J);

hF = figure(100); clf
hA2 =axes('parent', hF);

x = 244;

plot(J(:, x))