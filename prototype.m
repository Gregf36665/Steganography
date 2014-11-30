clear all 

% To test I will use a low res image as an import
% I have selected two colored pixels to be hidden 

cover = imread(input('File name: ','s'));
hidden(:,:,1) = [255;255];
hidden(:,:,2) = [255;255];
hidden(:,:,3) = [0;0];

dim_hidden = size(hidden);
dim_cover = size(cover);

% Calcualte the height and width of the hidden picture and cover:

hidden_height = dim_hidden(1);
hidden_width = dim_hidden(2);
cover_height = dim_cover(1);
cover_width = dim_cover(2);

% Find shortest binary length
% Unnessecery
% hidden_height_bit = floor(log2(hidden_height)+1);
% hidden_width_bit = floor(log2(hidden_width)+1);

% To figure out the number of bits required to encrypt the height and width

% bits_required = hidden_height_bit + hidden_width_bit;

% Convert both the cover and hidden image into a binary matrix

cover_bin = dec2bin(cover);
hidden_bin = dec2bin(hidden);

encryption = cover_height * cover_width; %this is the maximum encryption possible

cover_bit = rem(cover_bin(:,8),2); %this is the 8th bit

% Convert the height and width into a matrix of bits, use 16 to have 2 bytes and a maximum
% resolution of 65536 by 65536 pow(2,16)

hidden_height_bin = zeros(16,1);
hidden_width_bin = zeros(16,1);

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

% Encrypt the dimensions in one byte

for i=1:1:16,
cover_bit(i) = xor(cover_bit(i),hidden_height_bin(i)); 
end

for i=17:1:32,
cover_bit(i) = xor(cover_bit(i),hidden_width_bin(i-16));
end

% change the bits that are 1 but not the ones that are 0
for i=33:1:encryption,
cover_bit(i) = xor(cover_bit(i),hidden_bin(i));
end
