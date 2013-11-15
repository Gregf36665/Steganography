clear all 

% For comparison purpouses only:
x = audioread('test.wav');
xav = (x(:,1)+x(:,2))/2;

%%
% This is the decoder
% Where to start:
data = 1;

coded = imread(input('Coded file: ','s'));

dim_coded = size(coded);

% Calcualte the height and width of the coded image:

coded_height = dim_coded(1);
coded_width = dim_coded(2);
coded_size = coded_height * coded_width*3;


coded_bin = rem(coded,2);
coded_bin_string = num2str(coded_bin);

%% 
%{ 
This section is for calculating the bits per sample the sampling rate and
the duration of the song
%}

% Find the bits per sample:
bps_bin = '00000000';
for i=data:1:data+7,
    bps_bin(i-data+1) = coded_bin_string(i);
end
bps = bin2dec(bps_bin);

% Find the sampling rate for the sound
fs_bin = '000000000000000000000000';

for i=data+8:1:data+31,
    fs_bin(i-data-7) = coded_bin_string(i);
end

fs = bin2dec(fs_bin);


% Find the duration (note this is only accurate to 6.5535 seconds)
height_bin = '0000000000000000';
for i=data+32:1:data+47,
    height_bin(i-data-31) = coded_bin_string(i); 
end

height = bin2dec(height_bin);


% End of the dimension calculations

%% 
% Extract the audio
sound_bin = zeros(height*8,1);
bits = height*bps;

for i=data+48:1:bits+data+47,
    sound_bin(i-data-47,1) = coded_bin(i);
end

sound_bin_rot = rot90(sound_bin,1);
output(1:2,:) = zeros(2,height);

% convert to decimal 
for i=1:1:ceil(height),
    output(i) = bin2dec(num2str(sound_bin_rot(bps*i-(bps-1):bps*i)));
end

clear i; % tidy up

% rotate the output to be the correct orientation 
output = rot90(output,-1);
%%
% go from uint16 back to -1<=x<=1

% turn all of the audio from uint16:

% make the audio >= -1

noise = (output/(2^(bps-1)))-1;



