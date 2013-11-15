clear all

cover = imread(input('Cover: ','s'));
data = load(input('Binary file: ','s'));
data = data.output;

cover_bit = rem(cover,2);

encoded = cover;

for i=1:1:numel(data),
    if cover(i) ~= 255,
        encoded(i) = cover(i) + rem(cover(i) + data(i),2);
    else
        encoded(i) = cover(i) - rem(cover(i) + data(i),2);
    end
end

output = uint8(encoded);