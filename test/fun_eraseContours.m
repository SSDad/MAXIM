function [img_gray] = fun_eraseContours(img)

    img_gray = img(:,:,1);

    idxes_red = find((img(:,:,1) == 255) & (img(:,:,2) == 0) & (img(:,:,3) == 0));
    img_gray = erase_contour(idxes_red, img, img_gray, [255;0;0]);
    idxes_green = find((img(:,:,1) == 0) & (img(:,:,2) == 255) & (img(:,:,3) == 0));
    img_gray = erase_contour(idxes_green, img, img_gray, [0;255;0]);
    idxes_blue = find((img(:,:,1) == 0) & (img(:,:,2) == 0) & (img(:,:,3) == 255));
    img_gray = erase_contour(idxes_blue, img, img_gray, [0;0;255]);
        
    function img_gray = erase_contour(idxes_red, img, img_gray, set_red)
    [rr,cc] = ind2sub(size(img(:,:,1)), idxes_red);
        for idx_red = 1:length(rr),
            count = 0;
            sum = 0;
            if ~isequal(squeeze(img(rr(idx_red),cc(idx_red)+1,:)), set_red)
                count = count + 1;
                sum = sum + img(rr(idx_red),cc(idx_red)+1,1);
            elseif ~isequal(squeeze(img(rr(idx_red),cc(idx_red)-1,:)), set_red)
                count = count + 1;
                sum = sum + img(rr(idx_red),cc(idx_red)-1,1);
            elseif ~isequal(squeeze(img(rr(idx_red)+1,cc(idx_red),:)), set_red)
                count = count + 1;
                sum = sum + img(rr(idx_red)+1,cc(idx_red),1);
            elseif ~isequal(squeeze(img(rr(idx_red)-1,cc(idx_red),:)), set_red)
                count = count + 1;
                sum = sum + img(rr(idx_red)-1,cc(idx_red),1);
            end
            img_gray(rr(idx_red),cc(idx_red)) = round(sum/count);
        end
    end
end