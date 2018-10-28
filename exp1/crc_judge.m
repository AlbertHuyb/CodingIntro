function [ flag,error ] = crc_judge( data,num )
%CRC_ 此处显示有关此函数的摘要
%   此处显示详细说明
%[ flag,error ] = crc_judge( data,num )
%   flag: 数据是否正确
%   error: 误码图案，数据正确时取-1
%   data: 用于判断的数据
%   num: crc长度，支持1，3,5，7，8，10，12，16

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
[~,res]=deconv(data,table{index});
res = mod(res,2);
if sum(res)==0
    flag = 1;
else
    flag = 0;
end
end

