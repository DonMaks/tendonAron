function [sharpness, maxIndex] = brenner(stack)
sharpness = zeros(size(stack, 3), 1);
shift_px = 2;
for i = 1:size(stack,3)
    first_image = stack(1:end-shift_px, :, i);
    shift_image = stack(shift_px+1:end, :, i);
    diff2 = (first_image-shift_image).^2;
    sharpness(i) = sum(diff2(:));
    
end
[~, maxIndex] = max(sharpness);