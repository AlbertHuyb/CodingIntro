function [ data ] = temp_demodulate( input,symbol_num,bias_amount,symbol )
%TEMP_DEMODULATE 此处显示有关此函数的摘要
%   此处显示详细说明
avg_vec = sum(input)/length(input);
phi0 = angle(avg_vec);
data = input.*exp(-1j*phi0);
end

