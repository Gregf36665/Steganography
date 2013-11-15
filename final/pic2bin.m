x=input('Image to convert: ', 's');
pic = imread(x);
data = imfinfo(x);
%%
% Find the dimensions of the image and convert them to binary
width = data.Width;
height = data.Height;

width_bin = dec2bin(width,16);
height_bin = dec2bin(height,16);
%%
pic = double(pic);

pic_vector= reshape(pic,1,[],1);

pic_vector_bin = dec2bin(pic_vector,8);

pic_vector_bin = flipdim(rot90(pic_vector_bin,3),2);
% This will output a string of binary

output = zeros(width*height*8*3+32,1);

%%
%{
Coding standard:
 Height  Width      Data
 16 bit  16bit  w*h*8 bit
%}
disp('Encoding dimensions');
for i=1:1:16,
    output(i) = str2double(height_bin(i));
end

for i=17:1:32,
    output(i) = str2double(width_bin(i-16));
end

disp('Complete');
disp('Encoding data');

for i=33:1:numel(pic_vector_bin)+32,
    output(i) = str2double(pic_vector_bin(i-32));
end

disp('Complete');
disp('Converting to string');

output = num2str(output);

disp('Complete');

%%
% This command saves the binary string as a file called pic.mat
savefile = 'pic.mat';
save(savefile, 'output');

