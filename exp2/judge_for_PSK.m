function [ symbol_index,prob ] = judge_for_PSK( input,symbol_num,len,symbol,repeat_time)
%SOLVE_ANGLE �������ӵ�10���������ģʽһ�е���ת�Ƕ�
%   [ sympbol_index ] = judge_for_PSK( input,symbol_num,gray_enable)
%       symbol_index: �õ����ŵ����
%       input: �����ŵ�֮��ĵ�ƽ����
%       symbol_num: ������
%       length: ǰ�÷�����
% avg_vec = sum(input(1:len))/len;
% phi0 = angle(avg_vec);
% data = input(len+1:end).*exp(-1j*phi0);
data = input(len+1:end);
data = reshape(data.',[length(input)/repeat_time,repeat_time]).';
data = sum(data,1)/repeat_time;
phi_all = angle(data);
% phi_all = phi_all-phi0;
phi_all(phi_all<-pi)=phi_all(phi_all<-pi)+2*pi;
phi_all(phi_all>pi)=phi_all(phi_all>pi)-2*pi;
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
prob = -abs(repmat(data,symbol_num,1)-repmat((symbol).',1,length(data))).^2;
end
