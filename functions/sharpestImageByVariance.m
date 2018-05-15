function [sharpness, maxIndex] = sharpestImageByVariance(stack)
%SHARPESTIMAGEBYVARIANCE Calculate the sharpness of images in a stack.
%   The sharpness of image I is calculated as the sum of squares of the
%   deviation of the mean intensity of every pixel of I. As only the
%   sharpness of the nucleus is of interest the border regions are excluded
%   from the analysis by applying a dilated mask of the thresholded
%   nucleus (mask_dil) before summation.
mask = imbinarize(stack);
mask = getLargestCc(mask);
mask_dil = imdilate(mask, strel('disk', 7));
sharpness = zeros(size(stack, 3), 1);

for i = 1:size(stack,3)
    image = stack(:, :, i);
    meanIntensity = mean(image(:));
    diff = image - meanIntensity;
    diff2 = diff.^2;
    masked_diff2 = immultiply(diff2, mask_dil(:, :, i));
    sharpness(i) = sum(masked_diff2(:)); 
end
[~, maxIndex] = max(sharpness);
end

