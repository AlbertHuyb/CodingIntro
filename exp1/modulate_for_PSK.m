function [ out,symbol ] = modulate_for_PSK( input, symbol_num, gray_enable, amplify )
%MODULATE_FOR_PSK 此处显示有关此函数的摘要
%   此处显示详细说明
%[ out ] = modulate_for_PSK( input, symbol_num, gray_enable, amplify )
%   input: 输入序列
%   symbol_num: 调制电平数量
%   gray_enable: 是否格雷映射
%   amplify: PSK 电平幅度

unit = log2(symbol_num);
input = reshape(input,unit,length(input)/unit)';
input = num2str(input);
integer_input = bin2dec(input);
if(gray_enable)
    integer_input = bin2gray(integer_input,'psk',symbol_num);
end
phi = 2*pi/symbol_num*(integer_input);
out = reshape(amplify.*exp(1i*phi),1,length(phi));

symbol = 0:symbol_num-1;
phis = 2*pi/symbol_num*(symbol);
symbol = reshape(amplify.*exp(1i*phis),1,length(phis));
end

