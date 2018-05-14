function [sharpness, maxIndex] = sharpestImage(stack, threshold)
sharpness = zeros(size(stack, 3), 1);

for i = 1:size(stack,3)
    edge_image = edge(stack(:,:,i), 'Canny', threshold);
    sharpness(i) = sum(edge_image(:));
end

[~, maxIndex] = max(sharpness);