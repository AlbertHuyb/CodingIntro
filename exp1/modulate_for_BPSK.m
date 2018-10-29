function [ out ] = modulate_for_BPSK( input, symbol_num, gray_enable, amplify ,bias_ratio)
%MODULATE_FOR_BPSK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%[ out ] = modulate_for_BPSK( input, symbol_num, gray_enable, amplify ��bias_ratio)
%   input: ��������
%   symbol_num: ���Ƶ�ƽ����
%   gray_enable: �Ƿ����ӳ��
%   amplify: PSK ��ƽ����
%   bias_ratio: ƫ�ñ���

unit = log2(symbol_num);
input = reshape(input,unit,length(input)/unit)';
input = num2str(input);
integer_input = bin2dec(input);
if(gray_enable)
    integer_input = bin2gray(integer_input,'psk',symbol_num);
end
phi = 2*pi/symbol_num*(integer_input);
out = reshape(amplify.*exp(1i*phi),1,length(phi))+bias_ratio*amplify;
end

