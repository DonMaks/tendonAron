function [out_stack] = subtractTophat(stack)
out_stack = zeros(size(stack));
for i = 1:size(stack, 3)
    out_stack(:, :, i) = imsubtract(stack(:, :, i), imtophat(stack(:, :, i), strel('disk', 2)));
end

