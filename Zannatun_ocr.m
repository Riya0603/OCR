



                            %Zannatun Naiem Riya
                            %TheSparksFoundation
                            %IoT&computervision
                            %Task1:OCR




clc;
close all;
clear all;
c = imread('handicapSign.jpg');
c = imresize(c,0.2);
d = rgb2gray(c);

% Detect MSER regions.
[mserRegions, mserConnComp] = detectMSERFeatures(d, ... 
    'RegionAreaRange',[200 8000],'ThresholdDelta',4);
figure
imshow(d)
hold on;
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('MSER regions');
hold off;
m = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

% Compute the aspect ratio using bounding box data.
bbox = vertcat(m.BoundingBox);
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;

% Threshold the data to determine which regions to remove. These thresholds
% may need to be tuned for other images.
filterddx = aspectRatio' > 3; 
filterddx = filterddx | [m.Eccentricity] > .995 ;
filterddx = filterddx | [m.Solidity] < .3;
filterddx = filterddx | [m.Extent] < 0.2 | [m.Extent] > 0.9;
filterddx = filterddx | [m.EulerNumber] < -4;

% Remove regions
m(filterddx) = [];
mserRegions(filterddx) = [];

% Show remaining regions
figure
imshow(d)
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('Removing Non-Text Regions ')
hold off     

aag=fspecial('average',[5,5]);
g=imfilter(d,aag);
g=2*imsubtract(d,g);
figure;
imshow(g);
