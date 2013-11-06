clear all 

% This code is cabable of dealing with audio


cover = imread(input('Cover: ','s'));
[hidden, sample_rate] = audioread(input('File to hide: ','s'));

dim_hidden = size(hidden);
dim_cover = size(cover);

% Check if the sound is in mono or stereo

hidden_width = dim_hidden(2);

if hidden_width == 2,
    stereo = true;
else
    stereo = false;
end

% Calcualte the height and width of the picture and the duration of the song (in samples):

hidden_height = dim_hidden(1);
cover_height = dim_cover(1);
cover_width = dim_cover(2);

encryption = hidden_height * hidden_width; %this is the required encryption

% Test the size of the cover
if (cover_height*cover_width<24)
    disp('cover too small (min 24px)');
    break
end

% Test the size of the audio clip
if (hidden_height * 8) >= ((cover_height * cover_width)/8),
    disp('Hidden audio too large');
    if strcmp(input('Compress audio? (Y/N) ','s'),'Y'),
        sample_rate = sample_rate/ceil(hidden_height*64/(cover_height*cover_width));
        msg = ['Compressed to ', num2str(sample_rate) , ' samples per second'];
        disp(msg);
        clear msg
    else
    break
    end
end

% Find the red green and blue channels of the cover image image:

cover_red = cover(:,:,1); 
cover_green = cover(:,:,2);
cover_blue = cover(:,:,3);

% Find the left and right if stereo
hidden_left = hidden(:,1);
if stereo,
    hidden_right = hidden(:,2);
else
    hidden_right = zeros(hidden_height,1);
end
hidden_sample = sample_rate;
% Convert  the cover image into a binary matrix as each
% seperate color

cover_bin_red = dec2bin(cover_red,8);
cover_bin_green = dec2bin(cover_green,8);
cover_bin_blue = dec2bin(cover_blue,8);

% turn all of the audio into uint8:

hidden_left = 128 * hidden_left;
hidden_right = 128 * hidden_right;

% if the number is negative then it will be >= 128
for i=1:1:hidden_height,
    if hidden_left(i) < 0,
        hidden_left(i) = -hidden_left(i) + 128;
    end
    if hidden_right(i) < 0,
        hidden_right(i) = -hidden_right(i) + 128;
    end
end

hidden_left = uint8(hidden_left);
hidden_right = uint8(hidden_right);


% Prepare to convert uint8 to binary:
hidden_bin_left = zeros(hidden_height,stereo+1);
hidden_bin_right = zeros(hidden_height,stereo+1);
hidden_bin_sample = dec2bin(hidden_sample,24); % this is at 24 bits as max sample ~2^24


cover_bit_red = cover_bin_red(:,8); %this is the 8th bit
cover_bit_green = cover_bin_green(:,8);
cover_bit_blue = cover_bin_blue(:,8);


% Set up the code stream
code_left = zeros(cover_height,cover_width);
code_right = zeros(cover_height,cover_width);
code_sample = zeros(cover_height,cover_width);



% change the bits that are 1 but not the ones that are 0
% start at `1 with left in red right in green and sample frequency in blue

% start the encryption

for i=17:1:(encryption*8)+16,
code_left(i) = str2double(hidden_bin_left(i-16));
end

for i=17:1:(encryption*8)+16,
code_right(i) = str2double(hidden_bin_right(i-16));
end

for i=17:1:(encryption*8)+16,
code_sample(i) = str2double(hidden_bin_sample(i-16));
end

% make the code_color into dimensions that match the original image (res for
% resolution)

% res_code_r = zeros(cover_height,cover_width);
% res_code_g = zeros(cover_height,cover_width);
% res_code_b = zeros(cover_height,cover_width);
% 
% for i=1:1:numel(code_r),
%     res_code_r(i) = char(str2double(code_r(i)));
%     res_code_g(i) = char(str2double(code_g(i)));
%     res_code_b(i) = char(str2double(code_b(i)));
% end

% perform the datashift 
%for red/left
for i=17:1:cover_height*cover_width,
if rem(cover_r(i),2) == 0,
    if code_left(i) == 0,
        continue
    else
        cover_r(i) = cover_r(i) + 1;    
    end
else
    if rem(cover_r(i),2) == 1,
        if code_left(i) == 1,
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

%for green/right
for i=1:1:cover_height*cover_width,
if rem(cover_g(i),2) == 0,
    if code_left(i) == 0,
        continue
    else
        cover_g(i) = cover_g(i) + 1;    
    end
else
    if rem(cover_g(i),2) == 1,
        if code_left(i) == 1,
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
    if code_sample(i) == 0,
        continue
    else
        cover_b(i) = cover_b(i) + 1;    
    end
else
    if rem(cover_b(i),2) == 1,
        if code_sample(i) == 1,
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


out_r = cover_r + rem(cover_r + uint8(code_right),2);
out_g = cover_g + rem(cover_g + uint8(code_g),2);
out_b = cover_b + rem(cover_b + uint8(code_sample),2);

% compile all of the data together
output = zeros(cover_height,cover_width,3);

output(:,:,1) = rem(out_r,256); 
output(:,:,2) = rem(out_g,256);
output(:,:,3) = rem(out_b,256);

output = uint8(output);
