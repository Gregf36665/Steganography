%% Read
% Ask for the coded file
clear all 
coded = imread(input('Coded file: ','s'));

dim_coded = size(coded);

%% Calcualte 
% Find the height and width of the coded image
coded_height = dim_coded(1);
coded_width = dim_coded(2);
coded_size = coded_height * coded_width;

%% Coded colors
% Find the RGB values

coded_r = coded(:,:,1); 
coded_g = coded(:,:,2);
coded_b = coded(:,:,3);

%% Coded binary
% Find the binary values of the RGB found previously

coded_bin_r = rem(coded_r,2);
coded_bin_g = rem(coded_g,2);
coded_bin_b = rem(coded_b,2);
disp('Binary values found');

%% Dimension
% Find the dimensions for the hidden image
height_hidden_bin = '0000000000000000';

for i=1:1:16,
    height_hidden_bin(i) = num2str(coded_bin_r(i));
end

height_hidden = bin2dec(height_hidden_bin);

width_hidden_bin = '0000000000000000';

for i=1:1:16,
    width_hidden_bin(i) = num2str(coded_bin_g(i));
end

width_hidden = bin2dec(width_hidden_bin);

clear i;
disp('Dimensions found');
% End of the dimension calculations
%% Size hidden image
% Make an array for the hidden image

hidden_dimensions = height_hidden * width_hidden;

hidden_r = zeros(height_hidden,width_hidden);
hidden_g = zeros(height_hidden,width_hidden);
hidden_b = zeros(height_hidden,width_hidden);

%% Hidden RGB
% Find the hidden RGB values in binary and convert them to double

% bits required:

bits = hidden_dimensions * 8;

% red
for i=1:1:hidden_dimensions,
    hidden_r(i) = bin2dec(num2str(coded_bin_r(8*i+9:8*i+16)));
end
disp('Red found');

% green
for i=1:1:hidden_dimensions,
    hidden_g(i) = bin2dec(num2str(coded_bin_g(8*i+9:8*i+16)));
end
disp('Green found');

% blue
for i=1:1:hidden_dimensions,
    hidden_b(i) = bin2dec(num2str(coded_bin_b(8*i+9:8*i+16)));
end
disp('Blue found');

%% Merge RGB
% Convert the doubles to uint8
hidden(:,:,1) = uint8(hidden_r);
hidden(:,:,2) = uint8(hidden_g);
hidden(:,:,3) = uint8(hidden_b);