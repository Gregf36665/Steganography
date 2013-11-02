function [S3,S2,S1] = parbits(binary_string)
%parbits return the parity bits of a 4 bit transmission
%   This code assumes that the encryption is [1,0,1,1;1,1,1,0;0,1,1,1]

if numel(binary_string) < 4
    if numel(binary_string) == 3
        binary_string(4) = binary_string(3);
        binary_string(3) = binary_string(2);
        binary_string(2) = binary_string(1);
        binary_string(1) = '0';
    end;
    if numel(binary_string) == 2
        binary_string(4) = binary_string(2);
        binary_string(3) = binary_string(1);
        binary_string(2) = '0';
        binary_string(1) = '0';
    end;
    if numel (binary_string) == 1
        binary_string(4) = binary_string(1);
        binary_string(1:3) = '0';
    end;
end;

%conver the string into numbers, b1 ==> bit 1:

b1 = str2double(binary_string(1));
b2 = str2double(binary_string(2));
b3 = str2double(binary_string(3));
b4 = str2double(binary_string(4));

btotal =[b1,b2,b3,b4];
disp('input: ');
disp(btotal);

% perform the logic to generate the bits
S3 = xor(b1,(xor(b3,b4)));
S2 = xor(b1,xor(b2,b3));
S1 = xor(b2,xor(b3,b4));

S = [S3, S2, S1];
disp('extra output: ');
disp(S);

disp('end');
end
