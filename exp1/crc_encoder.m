function [ out ] = crc_encoder( data, num )
%CRC_ENCODER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%[ out ] = crc_encoder( data, num )
%   out: �Ӻ�crc���������
%   data: Ҫ��CRC������
%   num: CRC��λ����֧��1��3,5��7��8��10��12��16
order = [1,3,5,7,8,10,12,16];
index = find(order==num);
table = cell(1,length(order));
table{1}=[1,1];
table{2}=[1,1,0,1];
table{3}=[1,0,1,0,1,1];
table{4}=[1,0,0,0,1,0,0,1];
table{5}=[1,1,0,0,0,1,1,0,1];
table{6}=[1,1,0,0,0,1,1,0,0,1,1];
table{7}=[1,1,0,0,0,0,0,0,0,1,1,1,1];
table{8}=[1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1];
[~,res]=deconv([data,repmat(0,1,num)],table{index});
res = mod(res,2);
out = [data,res(end-num+1:end)];
end
