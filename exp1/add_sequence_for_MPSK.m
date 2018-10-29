function [ out ] = add_sequence_for_MPSK( input, symbol_num, len)
%ADD_SEQUENCE 对于信道模式1，在序列的前边加10个符号的确定序列
%适用于MPSK，相位调制
% [ out ] = add_sequence( input, voltage_num )
%   input: 准备加序列的串
%   symbol_num: 映射符号数
%       - 2 符号， 在前面补上length个0
%       - 4 符号， 在前面补上length个00，总长度为2length
%       - 8 符号， 在前面补上length个000，总长度为3length
%   length: 补充长度
out = [zeros(1,len*log2(symbol_num)),input];

end

