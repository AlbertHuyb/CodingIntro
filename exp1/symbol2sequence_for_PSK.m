function [ code ] = symbol2sequence_for_PSK( input,symbol_num,gray_enable )
%SYMBOL2SEQUENCE �˴���ʾ�йش˺�����ժҪ
%[ code ] = symbol2sequence( input,symbol_num,gray_enable )
%   ������ŵ�����Լ����������Ƿ����ӳ��
%   �����ӳ������

order = input;
if gray_enable
    order = gray2bin(order,'psk',symbol_num);
end
code = dec2bin(order,log2(symbol_num));
code = code';
code = code(:);
code = str2num(code)';
end

