clear all 

% To test I will use a low res image as an import
% I have selected two colored pixels to be hidden 

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

cover_bin_r = dec2bin(cover_r);
cover_bin_g = dec2bin(cover_g);
cover_bin_b = dec2bin(cover_b);
hidden_bin_r = dec2bin(hidden_r);
hidden_bin_g = dec2bin(hidden_g);
hidden_bin_b = dec2bin(hidden_b);

if (hidden_height * hidden_width >= cover_height * cover_width),
    disp('Hidden image too large');
    break
end

encryption = hidden_height * hidden_width; %this is the required encryption

cover_bit_r = rem(cover_bin_r(:,8),2); %this is the 8th bit
cover_bit_g = rem(cover_bin_g(:,8),2);
cover_bit_b = rem(cover_bin_b(:,8),2);

% Convert the height and width into a matrix of bits, use 16 to have 2 bytes and a maximum
% resolution of 32768 by 32768 pow(2,15)

hidden_height_bin = zeros(1,16);
hidden_width_bin = zeros(1,16);

% Height:

x = hidden_height; % These variables are to perform the loop to make a binary string
p = 16;
while x ~= 0,
  p = p - 1;
  if rem(x,2) ~= 0,
    x = x - 1;
    hidden_height_bin(16) = 1;
  else
      hidden_height_bin(p) = 1;
      x = x / 2;
    if x == 1,       % This is to prevent the issue when x = 2: x/2 = 1 but the code still works if x = 1
        break;
    end
  end
end

% Width:

x = hidden_width; % These variables are to perform the loop to make a binary string
p = 15;
while x ~= 0,
  p = p - 1;
  if rem(x,2) ~= 0,
    x = x - 1;
    hidden_width_bin(16) = 1;
  else
      hidden_width_bin(p) = 1;
      x = x / 2;
    if x == 1,       % This is to prevent the issue when x = 2: x/2 = 1 but the code still works if x = 1
        break;
    end
  end
end

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
 code_r(i) = (str2double(hidden_bin_r(i-16)));
 end

for i=17:1:encryption,
code_g(i) = (str2double(hidden_bin_g(i-16)));
end

for i=17:1:encryption,
code_b(i) = (str2double(hidden_bin_b(i-16)));
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
out_r = cover_r + uint8(res_code_r);
out_g = cover_g + uint8(res_code_g);
out_b = cover_b + uint8(res_code_b);

% compile all of the data together
output = zeros(cover_height,cover_width,3);

output(:,:,1) = out_r; 
output(:,:,2) = out_g;
output(:,:,3) = out_b;

output = uint8(output);
