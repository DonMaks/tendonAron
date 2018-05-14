function [sharpness, maxIndex] = sharpestImage(stack)

sharpness = zeros(size(stack, 3), 1);
threshold = 0.8;
method = 'Canny';

for i = 1:size(stack,3)
    edge_image = edge(stack(:,:,i), method, threshold);
    sharpness(i) = sum(edge_image(:));
end

[~, maxIndex] = max(sharpness);