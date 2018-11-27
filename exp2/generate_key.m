function [ key ] = generate_key( string )
%GENERATE_KEY 此处显示有关此函数的摘要
%   此处显示详细说明
if(length(string)>5)
    error('The string is too long !')
end
str_index = lower(string)-'a'+1;
bin_code = dec2bin(str_index);
bin_code = [bin_code,zeros(length(string),5-size(bin_code,2))];
bin_code = [bin_code;zeros(5-size(bin_code,1),5)];
key = (bin_code=='1');
end

