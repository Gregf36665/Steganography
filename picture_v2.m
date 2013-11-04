clear all 

% This code is cabable of dealing with any images


cover = imread(input('Cover: ','s'));
hidden = imread(input('File to hide: ','s'));

dim_hidden = size(hidden);
dim_cover = size(cover);

% Calcualte the height and width of the hidden picture and cover:

hidden_height = dim_hidden(1);
hidden_width = dim_hidden(2);
cover_height = dim_cover(1);
cover_width = dim_cover(2);

% Find the red green and blue channels of each image:

cover_r = cover(:,:,1); 
cover_g = cover(:,:,2);
cover_b = cover(:,:,3);
hidden_r = hidden(:,:,1);
hidden_g = hidden(:,:,2);
hidden_b = hidden(:,:,3);

% Convert both the cover and hidden image into a binary matrix as each
% seperate color

cover_bin_r = dec2bin(cover_r,8);
cover_bin_g = dec2bin(cover_g,8);
cover_bin_b = dec2bin(cover_b,8);
hidden_bin_r = dec2bin(hidden_r,8);
hidden_bin_g = dec2bin(hidden_g,8);
hidden_bin_b = dec2bin(hidden_b,8);

if (hidden_height * hidden_width >= cover_height * cover_width),
    disp('Hidden image too large');
    break
end

encryption = hidden_height * hidden_width; %this is the required encryption

cover_bit_r = cover_bin_r(:,8); %this is the 8th bit
cover_bit_g = cover_bin_g(:,8);
cover_bit_b = cover_bin_b(:,8);

% Convert the height and width into a matrix of bits, use 16 to have 2 bytes and a maximum
% resolution of 32768 by 32768 pow(2,15)

hidden_height_bin = dec2bin(hidden_height,16);
hidden_width_bin = dec2bin(hidden_width,16);

% Set up the code stream
code_r = cover_bin_r(:,8);
code_g = cover_bin_g(:,8);
code_b = cover_bin_b(:,8);

% Encrypt the dimensions in four bytes with red as height green as width
% and then from 17 all are data

for i=1:1:16,
code_r(i) = num2str(hidden_height_bin(i)); 
end

for i=1:1:16,
code_g(i) = num2str(hidden_width_bin(i));
end

% change the bits that are 1 but not the ones that are 0
% start at 17 with  red in red green in green and blue in blue
 
 for i=17:1:encryption,
 code_r(i) = (hidden_bin_r(i-16));
 end

for i=17:1:encryption,
code_g(i) = (hidden_bin_g(i-16));
end

for i=17:1:encryption,
code_b(i) = (hidden_bin_b(i-16));
end

% make the code_color into dimensions that match the original image (res for
% resolution)

res_code_r = zeros(cover_height,cover_width);
res_code_g = zeros(cover_height,cover_width);
res_code_b = zeros(cover_height,cover_width);

for i=1:1:numel(code_r),
    res_code_r(i) = char(str2double(code_r(i)));
    res_code_g(i) = char(str2double(code_g(i)));
    res_code_b(i) = char(str2double(code_b(i)));
end

% perform the datashift 
%for red
for i=1:1:cover_height*cover_width,
if rem(cover_r(i),2) == 0,
    if res_code_r(i) == 0,
        continue
    else
        cover_r(i) = cover_r(i) + 1;    
    end
else
    if rem(cover_r(i),2) == 1,
        if res_code_r(i) == 1,
            continue
        else
            if cover_r(i) == 255,
                cover_r(i) = 254;
            else
                cover_r(i) = cover_r(i) + 1;
            end
        end
    end
end
end

%for green
for i=1:1:cover_height*cover_width,
if rem(cover_g(i),2) == 0,
    if res_code_g(i) == 0,
        continue
    else
        cover_g(i) = cover_g(i) + 1;    
    end
else
    if rem(cover_g(i),2) == 1,
        if res_code_g(i) == 1,
            continue
        else
            if cover_g(i) == 255,
                cover_g(i) = 254;
            else
                cover_g(i) = cover_g(i) + 1;
            end
        end
    end
end
end

%for blue
for i=1:1:cover_height*cover_width,
if rem(cover_b(i),2) == 0,
    if res_code_b(i) == 0,
        continue
    else
        cover_b(i) = cover_b(i) + 1;    
    end
else
    if rem(cover_b(i),2) == 1,
        if res_code_b(i) == 1,
            continue
        else
            if cover_b(i) == 255,
                cover_b(i) = 254;
            else
                cover_b(i) = cover_b(i) + 1;
            end
        end
    end
end
end


out_r = cover_r + rem(cover_r + uint8(res_code_r),2);
out_g = cover_g + rem(cover_g + uint8(res_code_g),2);
out_b = cover_b + rem(cover_b + uint8(res_code_b),2);

% compile all of the data together
output = zeros(cover_height,cover_width,3);

output(:,:,1) = rem(out_r,256); 
output(:,:,2) = rem(out_g,256);
output(:,:,3) = rem(out_b,256);

output = uint8(output);
