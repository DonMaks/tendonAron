clear all;
mfilepath = fileparts(which(mfilename));
addpath(fullfile(mfilepath, 'functions'));

zProjectionRange = 1; %the number of images around the sharpest detected image to use for segmentation

folder = 'P:\Aron-seg\TestData01\'; %folder containing your .png images

stack = loadData(folder);

[cropped_stack, shift] = cropStack(stack);

[sharpness, sharp_index] = sharpestImageByVariance(cropped_stack);

if sharp_index-zProjectionRange < 1
    sharp_stack = cropped_stack(:,:,1:sharp_index+zProjectionRange);
elseif sharp_index+zProjectionRange > size(cropped_stack, 3)
    sharp_stack = cropped_stack(:, :, sharp_index-zProjectionRange:end);
else
    sharp_stack = cropped_stack(:,:,sharp_index-zProjectionRange:sharp_index+zProjectionRange);
end
sharp_image = max(sharp_stack, [], 3);

bw = imbinarize(sharp_image);
bw_edges = edge(sharp_image, 'Canny', 0.3);
bw_sum = imadd(bw, bw_edges);
bw_sum(bw_sum>1) = 1;
bw_closed = logical(imclose(bw_sum, strel('disk', 5)));
bw_filled = imfill(bw_closed, 'holes');
bw_filled = getLargestCc(bw_filled);
result_image = imoverlay(sharp_image, boundarymask(bw_filled), [1, 0, 0]);

figure(1);
montage([cat(3, bw, bw, bw).*255, cat(3, bw_edges, bw_edges, bw_edges).*255, cat(3, bw_sum, bw_sum, bw_sum).*255;...
    cat(3, bw_closed, bw_closed, bw_closed).*255, cat(3, bw_filled, bw_filled, bw_filled).*255, result_image]);


% full_bw = zeros(size(stack));
% full_bw(shift(1):shift(1)+size(bw, 1)-1, shift(2):shift(2)+size(bw, 2)-1, sharp_index) = bw;

bw_stack = zeros(size(cropped_stack));
bw_stack(:, :, sharp_index) = boundarymask(bw_filled);
result = imoverlay3D(cropped_stack, bw_stack, [0.2 0 0]);

figure(2);
imshow3D(result);

disp(sharp_index);
