function [ out ] = crc_encoder( data, num, block_len )
%CRC_ENCODER 此处显示有关此函数的摘要
%   此处显示详细说明
%[ out ] = crc_encoder( data, num )
%   out: 加好crc冗余的码字
%   data: 要加CRC的数据
%   num: CRC的位数，支持1，3,5，7，8，10，12，16
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
block_num = length(data)/block_len;
out = zeros(1,block_num*(block_len+num));
for t=1:block_num
    [~,res]=deconv([data((t-1)*block_len+1:t*block_len),zeros(1,num)],table{index});
    res = mod(res,2);
    out((t-1)*(block_len+num)+1:t*(block_len+num)) =...
        [data((t-1)*block_len+1:t*block_len),res(end-num+1:end)];
end

