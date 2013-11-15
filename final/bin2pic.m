clear all

code = load(input('Binary string: ', 's'));

data_bin = reshape(code.output,8,[]);

height = bin2dec(data_bin(1:16));
width = bin2dec(data_bin(17:32));

hidden_image = zeros(height,width,3);

disp('Dimensions found');

for i=1:1:height*width*3,
    hidden_image(i) = bin2dec(data_bin((i+4)*8-7:(i+4)*8));
end

hidden_image = uint8(hidden_image);

image(hidden_image)