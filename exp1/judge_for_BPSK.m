function [ symbol_index,prob ] = judge_for_BPSK( input,symbol_num,bias_amount,symbol )
%JUDGE_FOR_BPSK 此处显示有关此函数的摘要
%   此处显示详细说明
%   [ symbol_index ] = judge_for_BPSK( input,symbol_num,gray_enable)
%       symbol_index: 得到符号的序号
%       input: 经过信道之后的电平序列
%       symbol_num: 符号数
%       bias_amount: 偏置量
avg_vec = sum(input)/length(input);
phi0 = angle(avg_vec);
data = input.*exp(-1j*phi0)-bias_amount;
phi_all = angle(data);
phi_all(phi_all<0)=phi_all(phi_all<0)+2*pi;%变到[0,2pi]区间
symbol_index = zeros(1,length(phi_all));
for i = 1:symbol_num
    if i==1
        index = (phi_all>-pi/symbol_num+2*pi | phi_all<pi/symbol_num);
    else
        index = (phi_all>-pi/symbol_num+(i-1)*2*pi/symbol_num & ...
            phi_all<pi/symbol_num+(i-1)*2*pi/symbol_num);
    end
    symbol_index(index) = i-1;    
end 
prob = -abs(repmat(data,symbol_num,1)-repmat((symbol-bias_amount).',1,length(data))).^2;
%data_inGF = mod(find(prodata_inGF==max(prodata_inGF)),8)';
%data_inGF(data_inGF==0) = 2^alphabetabits;
end

