%% Set up
% This reads all of the data in and makes it into the right format
clear all
noise=audioread('cookiemonster.wav');
figure('name','Audio');
plot(noise)
noise=noise(:,1);
sound(noise,44100)
cover=imread('test_out_1.png');
figure('name','Cover image');
figure(2)
image(cover)
hidden=imread('cameraman.png');
figure('name','Image to hide');
figure(3)
image(hidden)
cover=double(cover);
edit=cover;

%% Hide the picture
% this is basic addition on the first 256x256px
edit(1:256,1:256,:)=cover(1:256,1:256,:)+double(hidden)/100;
figure('name','Cover with image hidden');
figure(4)
image(edit/256)

%% Hide the sound
% This is basic addition on the next 64x1103px
noise=noise(1:70592,1); % Ensure the dimensions are correct

% Reshape to fit into the image
edit(257:320,1:1103,1)=(cover(257:320,1:1103,1))+reshape(noise,64,1103)*20+1; 

%% Show hidden
% Display the cover image with the hidden image and audio
figure('name','Cover with everythin hidden');
figure(5)
edit_uint = uint8(edit);
image(edit_uint)

%% Decode pic
% Extract the hidden image
figure('name','Extracted hidden image');
figure(6)
hidden_out = (edit(1:256,1:256,:)-(cover(1:256,1:256,:)))*100 ;
image(uint8(hidden_out))

%% Decode sound
% Extract the hidden audio
figure('name','Extracted audio');
audio_out=reshape(edit(257:320,1:1103,1)-cover(257:320,1:1103,1),70592,1);
figure(7)
plot(audio_out)
sound(audio_out/20,44100)