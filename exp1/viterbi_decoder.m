function [ out ] = viterbi_decoder( params, input )
%VITERBI_DECODER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
rate = length(param);
param = num2str(reshape(param,rate,1));
param = base2dec(param,8);
param = dec2bin(param);
param = double(param == '1');

end

