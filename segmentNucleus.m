clear all;
mfilepath = fileparts(which(mfilename));
addpath(fullfile(mfilepath, 'functions'));

zProjectionRange = 2;
constant_threshold = 0.25;

folder = 'P:\Aron-seg\8\'; %folder containing your .png images

stack = loadData(folder);

[cropped_stack, shift] = cropStack(stack);

[~, sharp_index] = sharpestImage(cropped_stack);

if sharp_index-n < 1
    sharp_stack = cropped_stack(:,:,1:sharp_index+zProjectionRange);
elseif sharp_index+n > size(cropped_stack, 3)
    sharp_stack = cropped_stack(:, :, sharp_index-zProjectionRange:end);
else
    sharp_stack = cropped_stack(:,:,sharp_index-zProjectionRange:sharp_index+zProjectionRange);
end
sharp_image = max(sharp_stack, [], 3);

bw = imbinarize(sharp_image, constant_threshold);
bw = imclose(bw, strel('disk', 5));

full_bw = zeros(size(stack));
full_bw(shift(1):shift(1)+size(bw, 1)-1, shift(2):shift(2)+size(bw, 2)-1, sharp_index) = bw;

result = imoverlay3D(stack, full_bw, [0.5 0 0]);

imshow3D(result);
