function [ symbol_index,prob ] = judge_for_PSK( input,symbol_num,len,symbol)
%SOLVE_ANGLE 利用添加的10个符号求解模式一中的旋转角度
%   [ sympbol_index ] = judge_for_PSK( input,symbol_num,gray_enable)
%       symbol_index: 得到符号的序号
%       input: 经过信道之后的电平序列
%       symbol_num: 符号数
%       length: 前置符号数
avg_vec = sum(input(1:len))/len;
phi0 = angle(avg_vec);
data = input(len+1:end).*exp(-1j*phi0);
phi_all = angle(input(len+1:end));
phi_all = phi_all-phi0;
phi_all(phi_all<-pi)=phi_all(phi_all<-pi)+2*pi;
phi_all(phi_all>pi)=phi_all(phi_all>pi)-2*pi;
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
prob = -abs(repmat(data,symbol_num,1)-repmat((symbol).',1,length(data))).^2;
end

