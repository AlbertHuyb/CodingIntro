function [ out,symbol ] = modulate_for_PSK( input, symbol_num, gray_enable, amplify )
%MODULATE_FOR_PSK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%[ out ] = modulate_for_PSK( input, symbol_num, gray_enable, amplify )
%   input: ��������
%   symbol_num: ���Ƶ�ƽ����
%   gray_enable: �Ƿ����ӳ��
%   amplify: PSK ��ƽ����

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

