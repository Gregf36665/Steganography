function [byte] = dec2byte(decimal)
%dec2byte Convert decimal to a 8 bit stream
%   Detailed explanation goes here
byte = zeros(1,8);
decimal = rem(decimal,256);
while decimal ~= 0,
    x = floor(log2(decimal));
    byte(8-x) = 1;
    decimal = decimal - pow2(x);
end

