clear all 

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


% turn all of the audio into uint16:

hidden_mono_positive = hidden_mono + 1;

% turn all of the audio into uint16:

hidden_mono_uint16 = 2^(bps-1) * hidden_mono_positive;

% Prepare to convert uint16 to binary:

hidden_bin_mono = dec2bin(hidden_mono_uint16,bps);
hidden_bin_sample_original = dec2bin(sample_rate,24); % this is at 24 bits as max sample ~2^24

disp('Converted audio to binary');

cover_bit = zeros(size(hidden) + [32,0]); % set the length to the amount of samples+32 for fs and bps

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
