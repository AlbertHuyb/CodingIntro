function [ symbol_index,prob ] = judge_for_BPSK( input,symbol_num,bias_amount,symbol )
%JUDGE_FOR_BPSK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   [ symbol_index ] = judge_for_BPSK( input,symbol_num,gray_enable)
%       symbol_index: �õ����ŵ����
%       input: �����ŵ�֮��ĵ�ƽ����
%       symbol_num: ������
%       bias_amount: ƫ����
avg_vec = sum(input)/length(input);
phi0 = angle(avg_vec);
data = input.*exp(-1j*phi0)-bias_amount;
phi_all = angle(data);
phi_all(phi_all<0)=phi_all(phi_all<0)+2*pi;%�䵽[0,2pi]����
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

