function [croppedStack, shift] = cropStack(stack)
%crop a stack to 1/16 its original area (middle)

n = 4;
croppedStack = stack(...
            round(size(stack,1)*(1-1/n)/2)+1:round(size(stack,1)*(1-(1-1/n)/2)),...
            round(size(stack,2)*(1-1/n)/2)+1:round(size(stack,2)*(1-(1-1/n)/2)),...
            :);

shift = [round(size(stack,1)*(1-1/n)/2)+1, round(size(stack,2)*(1-1/n)/2)+1];
end

