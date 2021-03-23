function [img_gray] = fun_eraseContours(img)

img_gray = img(:,:,1);

idxes_red = find((img(:,:,1) == 255) & (img(:,:,2) == 0) & (img(:,:,3) == 0));
img_gray = erase_contour(idxes_red, img, img_gray);
idxes_green = find((img(:,:,1) == 0) & (img(:,:,2) == 255) & (img(:,:,3) == 0));
img_gray = erase_contour(idxes_green, img, img_gray);
idxes_blue = find((img(:,:,1) == 0) & (img(:,:,2) == 0) & (img(:,:,3) == 255));
img_gray = erase_contour(idxes_blue, img, img_gray);

    function img_gray = erase_contour(idxes_red, img, img_gray)
        [rr,cc] = ind2sub(size(img(:,:,1)), idxes_red);
        for idx_red = 1:length(rr),
            count = 0;
            sum = 0;
            
            % cross
            if check_rgb(squeeze(img(rr(idx_red),cc(idx_red)+1,:))),
                count = count + 1;
                sum = sum + single(img(rr(idx_red),cc(idx_red)+1,1)); end
            if check_rgb(squeeze(img(rr(idx_red),cc(idx_red)-1,:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red),cc(idx_red)-1,1)); end
            if check_rgb(squeeze(img(rr(idx_red)+1,cc(idx_red),:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)+1,cc(idx_red),1)); end
            if check_rgb(squeeze(img(rr(idx_red)-1,cc(idx_red),:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)-1,cc(idx_red),1)); end
            
            % diagonal
            if check_rgb(squeeze(img(rr(idx_red)+1,cc(idx_red)+1,:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)+1,cc(idx_red)+1,1)); end
            if check_rgb(squeeze(img(rr(idx_red)+1,cc(idx_red)-1,:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)+1,cc(idx_red)-1,1)); end
            if check_rgb(squeeze(img(rr(idx_red)-1,cc(idx_red)+1,:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)-1,cc(idx_red)+1,1)); end
            if check_rgb(squeeze(img(rr(idx_red)-1,cc(idx_red)-1,:)))
                count = count + 1;
                sum = sum + single(img(rr(idx_red)-1,cc(idx_red)-1,1)); end
            img_gray(rr(idx_red),cc(idx_red)) = round(sum/count);
        end
        
        function isnt_rgb = check_rgb(pixx)
            set_red = [255;0;0];
            set_green = [0;255;0];
            set_blue = [0;0;255];
            
            isnt_rgb = ~isequal(pixx, set_red) & ~isequal(pixx, set_green) & ~isequal(pixx, set_blue);
        end
    end

    
end