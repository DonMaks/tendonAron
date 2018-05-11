clear all;
mfilepath = fileparts(which(mfilename));
addpath(fullfile(mfilepath, 'functions'));

folder = 'P:\Aron-seg\1\00-001'; %folder containing your .png images

stack = loadData(folder);

[cropped_stack, shift] = cropStack(stack);

[~, sharp_index] = brenner(cropped_stack);

sharp_image = cropped_stack(:,:,sharp_index);

bw = imbinarize(sharp_image);

full_bw = zeros(size(stack));
full_bw(shift(1):shift(1)+size(bw, 1)-1, shift(2):shift(2)+size(bw, 2)-1, sharp_index) = bw;

result = imoverlay3D(stack, full_bw, [0.5 0 0]);

imshow3D(result);
