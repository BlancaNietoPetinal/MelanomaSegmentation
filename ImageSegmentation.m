clear; clc;
%% First step: create MSB image
% Read image
img = imread('DataSet/Example2.jpeg');

% Extract color channels.
redChannel = img(:,:,1);
greenChannel = img(:,:,2);
blueChannel = img(:,:,3);

% Get bin str matrix
binRedChannel = dec2bin(redChannel);
binGreenChannel = dec2bin(greenChannel);
binBlueChannel = dec2bin(blueChannel);

% Extract Most Significant Bit
MSBRedChannel = binRedChannel(:,1);
MSBGreenChannel = binGreenChannel(:,1);
MSBBlueChannel = binBlueChannel(:,1);

% Convert str to num
MSBRedChannel = str2num(MSBRedChannel);
MSBGreenChannel = str2num(MSBGreenChannel);
MSBBlueChannel = str2num(MSBBlueChannel);

% Reshape matrix
MSBRedChannel = reshape(MSBRedChannel,size(redChannel,1),[]);
MSBGreenChannel = reshape(MSBGreenChannel,size(greenChannel,1),[]);
MSBBlueChannel = reshape(MSBBlueChannel,size(blueChannel,1),[]);

% Plot Masks
figure,
subplot(2,3,1);
imshow(MSBRedChannel);
title('Red Mask');
subplot(2,3,2);
imshow(MSBBlueChannel);
title('Blue Mask');
subplot(2,3,3);
imshow(MSBGreenChannel);
title('Green Mask');

%% Second step: Hanning Filter
w = hanning(7)*hanning(7)';
filteredRMSB= imfilter(MSBRedChannel, w);
filteredGMSB= imfilter(MSBGreenChannel, w);
filteredBMSB= imfilter(MSBBlueChannel, w);

filteredRMSB= filteredRMSB./max(filteredRMSB);
filteredBMSB= filteredBMSB./max(filteredBMSB);
filteredGMSB= filteredGMSB./max(filteredGMSB);


% 1-bit quantization
q = quantizer('float','round',[3 1]);
filteredRMSB = quantize(q,filteredRMSB);
filteredBMSB = quantize(q,filteredBMSB);
filteredGMSB = quantize(q,filteredGMSB);

% figure,
subplot(2,3,4);
imshow(filteredRMSB);
title('Red Filtered Mask');
subplot(2,3,5);
imshow(filteredGMSB);
title('Blue Filtered Mask');
subplot(2,3,6);
imshow(filteredBMSB);
title('Green Filtered Mask');

%% Third step: Bit Planes Summation
figure,
imgSum = filteredRMSB + filteredGMSB + filteredBMSB;
imshow('DataSet/Example2.jpeg');hold on;
contour(imgSum);
