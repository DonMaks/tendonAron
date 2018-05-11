function stack = loadData(directory)
%loadAndCropData: Load all the images from a folder into a stack and crop
%out the middle fourth.
    files = dir(fullfile(directory, '*.png'));
    img = imread(fullfile(directory,files(1).name));
    stack = zeros([size(img), length(files)]);
    for i = 1:length(files)
        img = imread(fullfile(directory, files(i).name));
        stack(:,:,i) = img;
    end
    stack = mat2gray(stack, [0 255]);
end