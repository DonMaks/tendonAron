clear all;
mfilepath = fileparts(which(mfilename));
addpath(fullfile(mfilepath, 'functions'));

zProjectionRange = 1; %the number of images around the sharpest detected image to use for segmentation

folder = 'P:\Aron-seg\TestData09\'; %folder containing your .png images

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



% figure(1);
% montage([cat(3, bw, bw, bw).*255, cat(3, bw_edges, bw_edges, bw_edges).*255, cat(3, bw_sum, bw_sum, bw_sum).*255;...
%     cat(3, bw_closed, bw_closed, bw_closed).*255, cat(3, bw_filled, bw_filled, bw_filled).*255, result_image]);
% 

% full_bw = zeros(size(stack));
% full_bw(shift(1):shift(1)+size(bw, 1)-1, shift(2):shift(2)+size(bw, 2)-1, sharp_index) = bw;

bw_stack = zeros(size(cropped_stack));
bw_stack(:, :, sharp_index) = boundarymask(bw_filled);
result = imoverlay3D(cropped_stack, bw_stack, [0.2 0 0]);

% figure(2);
% imshow3D(result);

%calculate orientation of the ellipse (saved in stats.Orientation),
%stats.Orientation goes from -90 to 90 degrees (see regionprops doc)
stats = regionprops(bw_filled, 'Orientation', 'Centroid', 'MajorAxisLength', 'MinorAxisLength');

%visualization
figure(3);
imshow(bw_filled);
hold on;
%plot ellipse
t = linspace(0,2*pi,50);

a = stats.MajorAxisLength/2;
b = stats.MinorAxisLength/2;
x_centr = stats.Centroid(1);
y_centr = stats.Centroid(2);
phi = deg2rad(-stats.Orientation);
x_ellipse = x_centr + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
y_ellipse = y_centr + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
plot(x_ellipse, y_ellipse, 'r','Linewidth',1)

x_major = linspace(x_centr-1.2*a*cos(phi), x_centr+1.2*a*cos(phi), 2);
y_major = linspace(y_centr-1.2*a*sin(phi), y_centr+1.2*a*sin(phi), 2);
plot(x_major, y_major, 'b', 'Linewidth', 2)

x_ref = linspace(x_centr-1.2*a, x_centr+1.2*a, 2);
y_ref = linspace(y_centr, y_centr, 2);
plot(x_ref, y_ref, ':b');


disp(sharp_index);
