clear all 

% This is the decoder

coded = imread(input('Coded file: ','s'));

dim_coded = size(coded);

% Calcualte the height and width of the coded image:

coded_height = dim_coded(1);
coded_width = dim_coded(2);
coded_size = coded_height * coded_width;
% Find the red green and blue channels of the image:

coded_r = coded(:,:,1); 
coded_g = coded(:,:,2);
coded_b = coded(:,:,3);

%convert them to binary:

coded_bin_r = dec2bin(coded_r,8);
coded_bin_g = dec2bin(coded_g,8);
coded_bin_b = dec2bin(coded_b,8);

coded_bit_r = coded_bin_r(:,8); %this is the 8th bit
coded_bit_g = coded_bin_g(:,8);
coded_bit_b = coded_bin_b(:,8);

% Find the dimensions for the hidden image
height_hidden_bin = '0000000000000000';

for i=1:1:16,
    height_hidden_bin(i) = num2str(coded_bit_r(i));
end

height_hidden = bin2dec(height_hidden_bin);

width_hidden_bin = '0000000000000000';

for i=1:1:16,
    width_hidden_bin(i) = num2str(coded_bit_g(i));
end

clear i;

width_hidden = bin2dec(width_hidden_bin);

hidden_r = zeros(height_hidden,width_hidden);
hidden_g = zeros(height_hidden,width_hidden);
hidden_b = zeros(height_hidden,width_hidden);

% find the values of r
% bits required:

bits = width_hidden * height_hidden * 8;


for i=2:1:bits/8,
    hidden_r(i) = bin2dec(num2str(str2double(coded_bit_r(8*i+1:8*i+8))));
end

for i=1:1:bits/8,
    hidden_g(i) = bin2dec(num2str(str2double(coded_bit_g(8*i+9:8*i+16))));
end

for i=1:1:bits/8,
    hidden_b(i) = bin2dec(num2str(str2double(coded_bit_b(8*i+9:8*i+16))));
end

hidden(:,:,1) = hidden_r;
hidden(:,:,2) = hidden_g;
hidden(:,:,3) = hidden_b;
