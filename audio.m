clear all 

% This code is cabable of dealing with audio
% The plan is to encode the first 24 red channels cover(1:24) with the sample rate then after
% that add the data in

cover = imread(input('Cover: ','s'));
sound = input('File to hide: ','s');

hiddenaudio = audioinfo(sound);
hidden = audioread(sound);
sample_rate = hiddenaudio.SampleRate;
bps = hiddenaudio.BitsPerSample;clear all 

% This code is cabable of dealing with audio
% This has been modifyed to make the sound mono
% The plan is to encode the first 24 red channels cover(1:24) with the sample rate then after
% that add the data in

% Where should it start (bit)?
data = 1;

% Read in the files
cover = imread(input('Cover: ','s'));
sound = input('File to hide: ','s');
disp('Reading audio');

hiddenaudio = audioinfo(sound);
hidden = audioread(sound);
sample_rate = hiddenaudio.SampleRate;
bps = hiddenaudio.BitsPerSample;
duration = hiddenaudio.Duration;

dim_hidden = size(hidden);
dim_cover = size(cover);


% Calcualte the height and width of the picture and the duration of the song (in samples):

hidden_height = hiddenaudio.TotalSamples;
cover_height = dim_cover(1);
cover_width = dim_cover(2);

encryption = hidden_height; %this is the required encryption

%% 
%{
Error control:
First test is to examine the size of the cover image.  Next is to examine
the duration of the file.  The code is set up so that the maximum duration
of sound is (2^16)/10000 = 6.5536 seconds, just over one miniute.
%}

% Test the size of the cover
if (cover_height*cover_width<8)
    disp('cover too small (min 8px)');
    break
end

% Test the duration of the audio clip

if duration > 6.5535,
    disp('Audio clip too long');
    break
end

% Test the size of the audio clip
% This error test is no longer valid
if (duration * bps * sample_rate) >= (((cover_height * cover_width)-48-data)/8),
    disp('Hidden audio too large');
    if strcmp(input('Compress audio? (Y/N) ','s'),'Y'),
        sample_rate = floor(sample_rate/ceil(hidden_height*128/(cover_height*cover_width)));
        msg = ['Compressed to ', num2str(sample_rate) , ' samples per second'];
        disp(msg);
        clear msg
    else
    break
    end
end
disp('Error check PASS');

%% 

% Convert the cover into bytes

cover_bin = dec2bin(cover,8);

% Find the mono
hidden_mono = (hidden(:,1) + hidden(:,2))/2;


% Convert  the cover image into a binary matrix as each
% seperate color

% turn all of the audio into uint16:

hidden_mono = (hidden_mono+1)*(2^(bps-1));

% Prepare to convert uint16 to binary:

hidden_bin_mono = dec2bin(hidden_mono,bps);
hidden_bin_sample_original = dec2bin(sample_rate,24); % this is at 24 bits as max sample ~2^24

disp('Converted audio to binary');

cover_bit = zeros(size(hidden) + [24,0]); % set the length to the amount of samples + 24 for fs

% rotate the matrix 270 degrees CCW and then reflect the
% matrix vertically

hidden_bin_mono = flipdim(rot90(hidden_bin_mono,3),2);
hidden_bin_sample = flipdim(rot90(hidden_bin_sample_original,3),2);

% change the bits that are 1 but not the ones that are 0
% start at 1
%% 
% start the encryption

disp('encoding image');

%sample rate
% perform the datashift 
%for everything

% First the bits per sample in a byte:
bps_bin = dec2bin(bps,8);

for i=data:1:data+7
    cover_bit(i)= str2double(bps_bin(i+1-data));
end

% then the sampling rate:

for i=data+8:1:data+31,
    cover_bit(i) = rem(str2double(hidden_bin_sample(i+1-data-8)),2);
end

%Duration (height):

duration_ms_bin = dec2bin(hidden_height,16);
for i=data+32:1:data+47,
    cover_bit(i) = str2double(duration_ms_bin(i+1-data-32)); 
end

%data

for i=data+48:1:hidden_height+data+47,
    cover_bit(i) = rem(str2double(hidden_bin_mono(i+1-data-48)),2);
end

cover_out = cover;

for i=1:1:numel(cover_bit),
    if cover_out(i+data-1) < 255
        cover_out(i+data-1) = cover_out(i+data-1) + rem(cover_bit(i)+cover_out(i+data-1),2);
    else
        cover_out(i+data-1) = cover_out(i+data-1) - rem(cover_bit(i)+cover_out(i+data-1),2);
    end
end
% compile all of the data together

output = cover_out;
duration = hiddenaudio.Duration;

dim_hidden = size(hidden);
dim_cover = size(cover);

% Check if the sound is in mono or stereo

hidden_width = dim_hidden(2);

if hiddenaudio.NumChannels == 2,
    stereo = true;
else
    stereo = false;
end

% Calcualte the height and width of the picture and the duration of the song (in samples):

hidden_height = hiddenaudio.TotalSamples;
cover_height = dim_cover(1);
cover_width = dim_cover(2);

encryption = hidden_height * hidden_width; %this is the required encryption

%% 
%{
Error control:
First test is to examine the size of the cover image.  Next is to examine
the duration of the file.  The code is set up so that the maximum duration
of sound is (2^16)/1000 = 65.536 seconds, just over one miniute.
%}

% Test the size of the cover
if (cover_height*cover_width<8)
    disp('cover too small (min 8px)');
    break
end

% Test the duration of the audio clip

if duration > 65.536,
    disp('Audio clip too long');
    break
end

% Test the size of the audio clip
% This error test is no longer valid
if (hidden_height * 16) >= ((cover_height * cover_width)/8),
    disp('Hidden audio too large');
    if strcmp(input('Compress audio? (Y/N) ','s'),'Y'),
        sample_rate = sample_rate/ceil(hidden_height*128/(cover_height*cover_width));
        msg = ['Compressed to ', num2str(sample_rate) , ' samples per second'];
        disp(msg);
        clear msg
    else
    break
    end
end


%% 

% Convert the cover into bytes

cover_bin = dec2bin(cover,8);

% Find the left and right if stereo
if stereo,
    hidden_left = hidden(:,1);
    hidden_right = hidden(:,2);
    if strcmp(input('Convert to mono? (Y/N)','s'),'Y'),
        hidden_left(:,1) = (hidden_left + hidden_right)/2;
        stereo = false;
    end
else
    hidden_left(:,1) = hidden_left;
end


% Convert  the cover image into a binary matrix as each
% seperate color

% turn all of the audio into uint16:

hidden_left = 2^bps * hidden_left;
if stereo,
    hidden_right = 2^bps * hidden_right;
else
    hidden_right = [];
end

% if the number is negative then it will be >= 2^bps
for i=1:1:hidden_height,
    if hidden_left(i) < 0,
        hidden_left(i) = -hidden_left(i) + 2^bps;
    end
    if and(hidden_right(i) < 0,stereo),
        hidden_right(i) = -hidden_right(i) + 2^bps;
    end
end

hidden_left = uint8(hidden_left);
hidden_right = uint8(hidden_right);


% Prepare to convert uint16 to binary:

hidden_bin_left = dec2bin(hidden_left,bps);
hidden_bin_right = dec2bin(hidden_right,bps);
hidden_bin_sample = dec2bin(sample_rate,24); % this is at 24 bits as max sample ~2^24

cover_bit = zeros(size(hidden) + [24,0]); % set the length to the amount of samples + 24 for fs

% rotate the matrix 270 degrees CCW and then reflect the
% matrix vertically

hidden_bin_left = flipdim(rot90(hidden_bin_left,3),2);
hidden_bin_right = flipdim(rot90(hidden_bin_right,3),2);
hidden_bin_sample = flipdim(rot90(hidden_bin_sample,3),2);

% change the bits that are 1 but not the ones that are 0
% start at `1 with left in red right in green and sample frequency in blue

% start the encryption

disp('encoding image');

%sample rate
% perform the datashift 
%for everything
% Where should it start (bit)?

data = 1;

% First the bits per sample in a byte:
bps_bin = dec2bin(bps,8);

for i=data:1:data+7
    cover_bit(i)= str2double(bps_bin(i+1-data));
end

for i=data+8:1:data+31,
cover_bit(i) = rem(str2double(hidden_bin_sample(i+1-data-8)),2);
end

%Duration:

duration_ms = round(duration*10000);
duration_ms_bin = dec2bin(duration_ms,16);
for i=data+32:1:data+47,
    cover_bit(i) = str2double(duration_ms_bin(i+1-data-32)); 
end
%data

for i=data+48:1:hidden_height+data+47,
cover_bit(i) = rem(str2double(hidden_bin_left(i+1-data-48)),2);
end
if stereo
    for i=data+48:1:hidden_height+data+47,
    cover_bit(i+hidden_height) = rem(str2double(hidden_bin_right(i+1-data-48)),2);
    end
end


cover_out = cover;


for i=1:1:numel(cover_bit),
cover_out(i+data-1) = cover_out(i+data-1) + cover_bit(i);
end

% compile all of the data together

output = cover_out;
