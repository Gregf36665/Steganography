clear all
code = load('noise.mat', 'noise_vector_bin') ;

data_bin = reshape(code.noise_vector_bin,[],8);

data_uint = bin2dec(data);

data_sint = data_uint;