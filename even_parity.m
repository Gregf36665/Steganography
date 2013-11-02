%This is an encrypter using a parity check (even)

bitstream = input('Bit stream: ','s');
dim = numel(bitstream);
x = str2double(bitstream);
p0 = 0;
p1 = 0;
while x >= 1,
    if rem(bin2dec(bitstream),2) == 0,
    x = x / 2;
    p1 = p1 + 1;
    else
    x = x - 1;
    end
end


if and((rem(p1,2) == 0),(p1 ~= 0)),
   bitstream(dim+1) = '1';
else
    bitstream(dim+1) = '0';
end

disp(bitstream);
