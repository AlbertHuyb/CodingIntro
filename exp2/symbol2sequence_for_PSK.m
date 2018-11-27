function [ code ] = symbol2sequence_for_PSK( input,symbol_num,gray_enable )
%SYMBOL2SEQUENCE 此处显示有关此函数的摘要
%[ code ] = symbol2sequence( input,symbol_num,gray_enable )
%   输入符号的序号以及符号数，是否格雷映射
%   输出解映射序列

order = input;
if gray_enable
    order = gray2bin(order,'psk',symbol_num);
end
code = dec2bin(order,log2(symbol_num));
code = code';
code = code(:);
code = str2num(code)';
end

