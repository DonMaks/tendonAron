function [sharpness, maxIndex, edges] = brenner(stack)
mask = imbinarize(stack);
mask = getLargestCc(mask);
mask_dil = imdilate(mask, strel('disk', 7));
sharpness = zeros(size(stack, 3), 1);
edges = zeros(size(stack, 1)-2, size(stack, 2), size(stack, 3));
shift_px = 2;
mask_dil = mask_dil(1+round(shift_px/2):end-round(shift_px/2), :, :);
for i = 1:size(stack,3)
    first_image = stack(1:end-shift_px, :, i);
    shift_image = stack(shift_px+1:end, :, i);
    diff2 = (first_image-shift_image).^2 .* mask_dil(:, :, i);
    edges(:, :, i) = diff2;
    sharpness(i) = sum(diff2(:));
    
end
[~, maxIndex] = max(sharpness);