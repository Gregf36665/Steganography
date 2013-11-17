clear all
x=input('Audio to convert: ', 's');
[noise_sint,fs] = audioread(x,'native');
data = audioinfo(x);
bps = data.BitsPerSample;

% Check if mono
if data.NumChannels == 2;
    noise_sint = (noise_sint(:,1)+noise_sint(:,2))/2;
end

%%
% Find the duration of the sound and bps and total samples
% and convert them to binary

duration = data.TotalSamples;
duration_bin = dec2bin(duration,16);
fs_bin = dec2bin(fs,16);
bps_bin = dec2bin(bps,8);
disp('Calculating');

%%
% Make the noise uint(bps):

noise_uint = noise_sint + 2^(bps-1);

noise_vector= reshape(noise_uint,1,[],1);

noise_vector_bin = dec2bin(noise_vector,8);

noise_vector_bin = flipdim(rot90(noise_vector_bin,3),2);
% This will output a string of binary

output = zeros(duration*fs*bps+32+bps,1);
disp('Calculated');
disp('Converting');
%%
%{
Coding standard:
 duration  fs      bps     Data
 16 bit    16bit   8bit     w*h*bps
%}

for i=1:1:16,
    output(i) = str2double(duration_bin(i));
end


for i=17:1:32,
    output(i) = str2double(fs_bin(i-16));
end

for i=33:1:40,
    output(i) = str2double(bps_bin(i-32));
end

for i=40:1:numel(output),
    output(i) = str2double(noise_vector_bin(i-40));
end

output = num2str(output);
%%
% This command saves the binary string as a file called pic.mat
savefile = 'pic2.mat';
save(savefile, 'output');
