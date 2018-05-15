function [sharpness, maxIndex, edges] = sharpestImage(stack, threshold)
sharpness = zeros(size(stack, 3), 1);
edges = zeros(size(stack));

for i = 1:size(stack,3)
    edge_image = edge(stack(:,:,i), 'Canny', threshold);
    edges(:, :, i) = edge_image;
    sharpness(i) = sum(edge_image(:));
end

[~, maxIndex] = max(sharpness);