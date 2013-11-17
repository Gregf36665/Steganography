% Set up:
clear all
noise=audioread('cookiemonster.wav');
plot(noise)
noise=noise(:,1);
sound(noise,44100)
cover=imread('test_out_1.png');
figure(2)
image(cover)
hidden=imread('cameraman.png');
figure(3)
image(hidden)
cover=double(cover);
edit=cover;
%%
% Hide the picture
edit(1:256,1:256,:)=cover(1:256,1:256,:)+double(hidden)/100;
figure(4)
image(edit/256)
%%
% Hide the sound
noise=noise(1:70592,1);

edit(257:320,1:1103,1)=(cover(257:320,1:1103,1))+reshape(noise,64,1103)*20+1;
figure(5)

%%
% Display the cover image with the hidden image and audio
edit_uint = uint8(edit);
image(edit_uint)

%%
% Decode the image
figure(6)
hidden_out = (edit(1:256,1:256,:)-(cover(1:256,1:256,:)))*100 ;
image(uint8(hidden_out))

%%
% Decode the audio
xr=reshape(edit(257:320,1:1103,1)-cover(257:320,1:1103,1),70592,1);
figure(7)
plot(xr)
sound(xr/20,44100)