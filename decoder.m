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

hidden = zeros(height_hidden,width_hidden,3);

% find the values of r
% bits required:

bits = width_hidden * height_hidden * 8;

hidden_r = hidden(:,:,1);
hidden_g = hidden(:,:,2);
hidden_b = hidden(:,:,3);

hidden_bit_r = rem(coded_r,2);
hidden_bit_g = rem(coded_r,2);
hidden_bit_b = rem(coded_r,2);
