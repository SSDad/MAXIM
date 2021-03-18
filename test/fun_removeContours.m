function [img_gray] = fun_removeContours(img)

vMax = 1;
if strcmp(class(img), 'uint8')
    vMax = 2^8-1;
end

img_gray = img(:,:,1);
[M, N] = size(img_gray);
maskR = (img(:,:,1) == vMax) & (img(:,:,2) == 0) & (img(:,:,3) == 0);
maskG = img(:,:,1) == 0 & img(:,:,2) == vMax & img(:,:,3) == 0;
maskB = (img(:,:,1) == 0) & (img(:,:,2) == 0) & (img(:,:,3) == vMax);
        
maskRGB = maskR|maskG|maskB;
indRGB = find(maskRGB);

for n = 1:length(indRGB)
    [r, c] = ind2sub([M N], indRGB(n));
    J = img_gray(r-1:r+1, c-1:c+1);
    ind = J == vMax | J == 0;
    img_gray(indRGB(n)) = sum(J(~ind))/(9-sum(ind(:)));
end