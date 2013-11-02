%This is an encrypter using a parity check (even)

bitstream = input('Bit stream: ','s');
dim = numel(bitstream);
x = str2double(bitstream);
p1 = 0;
for i=1:1:dim,
    if bitstream(i) == '1'
        p1 = p1 + 1;
    else
        continue;
    end
end


if (rem(p1,2) == 0),
   bitstream(dim+1) = '0';
else
    bitstream(dim+1) = '1';
end

disp(bitstream);
