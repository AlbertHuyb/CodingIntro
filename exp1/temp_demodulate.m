function [ data ] = temp_demodulate( input,symbol_num,bias_amount,symbol )
%TEMP_DEMODULATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
avg_vec = sum(input)/length(input);
phi0 = angle(avg_vec);
data = input.*exp(-1j*phi0);
end

