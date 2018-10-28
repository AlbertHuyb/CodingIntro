function [ out ] = viterbi_decoder( params, input )
%VITERBI_DECODER 此处显示有关此函数的摘要
%   此处显示详细说明
rate = length(param);
param = num2str(reshape(param,rate,1));
param = base2dec(param,8);
param = dec2bin(param);
param = double(param == '1');

end

