function [sharpness, maxIndex] = sharpestImageByGradientRing(stack)
%SHARPESTIMAGEBYGRADIENT Calculate the sharpness of images in a stack.
%   The sharpness of image I is calculated from image gradients which were
%   obtained by applying a vertical and horizontal sobel filter. Only the
%   region around the nucleus are used for the sharpness calculation
%   (multiplication of the gradient image with a dilated nucleus mask). To
%   get rid of small dot artefacts that would dominate the sum of gradients
%   the tophat transform of the image is first subtracted.
[counts, ~] = imhist(stack(:));
otsu_threshold = otsuthresh(counts);
template_mask = imbinarize(stack(:, :, round(size(stack, 3)/2)), otsu_threshold);
template_mask = getLargestCc(template_mask);
template_ring = bwperim(template_mask);
template_ring_dil = imdilate(template_ring, strel('disk', 5));
sharpness = zeros(size(stack, 3), 1);
sobh = fspecial('sobel');
sobv = sobh';
threshold = 0;
stack = subtractTophat(stack);

for i = 1:size(stack,3)
    image = stack(:, :, i);
    filt_imageh = imfilter(image, sobh);
    filt_imagev = imfilter(image, sobv);
    s = filt_imageh.^2+filt_imagev.^2;
    s_thresholded = s;
    s_thresholded(s_thresholded < threshold) = 0;
    masked_s = immultiply(s_thresholded, template_ring_dil);
    sharpness(i) = sum(masked_s(:)); 
end
[~, maxIndex] = max(sharpness);
end

