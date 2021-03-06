%{
%% Load  image
clear all;
clc;

img_list = {'p001', 'p002', 'p003'};
for i = 1:length(img_list)
img = imread([img_list{i} '.png']);  % already grayscale

%% Find Circles (Use hough transform for circles)
[centers, radii] = find_circles(img, [3,10]);
img = hough_circles_draw(img, centers, radii);
imwrite(im2double(img), ['hough_circles_' img_list{i} '.png']);
end
%}


%% Load  image
clear all;
clc;

img_list = {'p012'};
for i = 1:length(img_list)

disp(['Reading image.....' img_list{i} '.png'])
img = imread([img_list{i} '.png']);  % already grayscale
%% Find Circles (Use hough transform for circles)
disp('Finding circles.....')
[centers, radii] = find_circles(img, [3,10]);

disp('Drawing circles.....')
circle_img = hough_circles_draw(img, centers, radii);
imwrite(im2double(circle_img), ['hough_circles_' img_list{i} '.png']);

disp('Filling circles.....')
%binaryImage = imfill(hough_circle_img,'holes')

%{
img2=img;
mask = img2 > 0.5;
subplot(2,2,2);
imshow(mask);
title('Binary Image', 'FontSize', 20);
% Now everywhere that mask is true, set the original image to zero there.
img2(mask) = 0;
% Display the result.
subplot(2,2,3);
imshow(img2);
title('New Image', 'FontSize', 20);
%}


noteheads_closing_img = imread('note_heads_detected_with_closing.png');
[height width] = size(noteheads_closing_img)
mask = zeros(height, width, 'uint8')

hough_circle_img = hough_circles_draw(mask, centers, radii);
imwrite(im2double(hough_circle_img), ['hough_circles_drawn_' img_list{i} '.png']);

% Get size of existing image A.
[rowsA colsA] = size(noteheads_closing_img);
% Get size of existing image B.
[rowsB colsB] = size(hough_circle_img);
% See if lateral sizes match.
if rowsB ~= rowsA || colsA ~= colsB
% Size of B does not match A, so resize B to match A's size.
hough_circle_img = imresize(hough_circle_img, [rowsA colsA]);
end

final_img = hough_circle_img | noteheads_closing_img;
%{
img_list_2 = {hough_circle_img,noteheads_closing_img};
[height width] = size(noteheads_closing_img)
mask = zeros(height,width);
for i = 1:length(img_list_2)
    img = imread([img_list_2{i} '.png']);
    for j=1:height
        for k=1:width
            if(img(j,k)~=0)
                mask(j,k)=1;
            end
        end
    end
end
imwrite(double(mask), 'mask.png');
%}
imwrite(im2double(final_img), ['FINAL_' img_list{i} '.png']);
%hough_circle_filled_img = imfill(hough_circles_draw_img,'holes');
%hough_circle_filled_img = imfill(hough_circle_img,radii,8);
%imwrite(im2double(hough_circle_filled_img), ['hough_circles_filled_' img_list{i} '.png']);
%result_img = ismember(hough_circle_img, img);
%imwrite(result_img, ['hough_circle_with_original_' img_list{i} '.png']);

vertFilteredImg = applyMedianFilter(img, 'vert');
noteStemCandidateImg = findNoteStemCandidates(vertFilteredImg);

noteStemImg = detectNoteStems(noteStemCandidateImg, final_img);
imwrite(noteStemImg,'Image with Stems.png');
end
