x=input('Audio to convert: ', 's');
[noise,fs] = audioread(x);
data = audioinfo(x);
bps = data.BitsPerSample;

% Check if mono
if data.NumChannels == 2;
    noise = (noise(:,1)+noise(:,2))/2;
end

%%
% Find the duration of the sound and bps and total samples
% and convert them to binary

duration = data.TotalSamples;
duration_bin = dec2bin(duration,16);
fs_bin = dec2bin(fs,16);
bps_bin = dec2bin(bps,8);

%%
% Make the noise uint(bps):

noise_uint = noise * 2^(bps-1);
noise_uint = double(noise_uint+2^(bps-1));

noise_vector= reshape(noise_uint,1,[],1);

noise_vector_bin = dec2bin(noise_vector,8);

noise_vector_bin = flipdim(rot90(noise_vector_bin,3),2);
% This will output a string of binary

output = zeros(width*height*8*3+32,1);

%%
%{
Coding standard:
 Height  Width      Data
 16 bit  16bit  w*h*8 bit
%}

for i=1:1:16,
    output(i) = str2double(height_bin(i));
end


for i=17:1:32,
    output(i) = str2double(width_bin(i-16));
end

for i=33:1:numel(output),
    output(i) = str2double(noise_vector_bin(i-32));
end

output = num2str(output);
%%
% This command saves the binary string as a file called pic.mat
savefile = 'pic.mat';
save(savefile, 'output');
