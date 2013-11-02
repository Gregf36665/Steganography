function [letter] = decoder_error()
%This code decrypts the bit stream before the parity bits have been removed
%   This function can deal with one bit of error
fullbitstream = input('binary code? ','s'); % this makes the function easier to work with

%make the bitstream intergers (these r values correspond to the paper work)

r6 = str2double(fullbitstream(1));
r5 = str2double(fullbitstream(2));
r4 = str2double(fullbitstream(3));
r3 = str2double(fullbitstream(4));
r2 = str2double(fullbitstream(5));
r1 = str2double(fullbitstream(6));
r0 = str2double(fullbitstream(7));

%Define the values for S:

S2= xor(r6,xor(r4,(xor(r3,r2))));
S1= xor(r6,xor(r5,xor(r4,r1)));
S0= xor(r5,xor(r4,xor(r3,r0)));

% Error correction:

r6 = xor(r6,and(S2,and(S1,~S0)));
r5 = xor(r5,and(~S2,and(S1,S0)));
r4 = xor(r4,and(S2,and(S1,S0)));
r3 = xor(r3,and(S2,and(~S1,S0)));
r2 = xor(r2,and(S2,and(~S1,~S0)));
r1 = xor(r1,and(~S2,and(S1,~S0)));
r0 = xor(r0,and(~S2,and(~S1,S0)));


x = (r6*2^3+r5*2^2+r4*2^1+r3*2^0);
letter = char('a'+x-1);
disp(letter);
end

