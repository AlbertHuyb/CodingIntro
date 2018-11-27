function [ code ] = convcode( data, param, tail )
%CONVCODE ������� depend on matlab r2016a
%   convcode(data,rate,param,tail)
%       data:    0 1 ���У�����������
%       param:   �б����а���ÿ��ͨ����8���Ʋ���(���ָ�ʽ),
%                ����Ч��Ϊ1/nʱ������Ӧ����n��Ԫ��
%       tail:    0��ʾ����β��1��ʾ��β

rate = length(param);
param = num2str(reshape(param,rate,1));
param = base2dec(param,8);
param = dec2bin(param);
param = double(param == '1');
memory =size(param,2);
code = [];

if ~tail
    for k = 1:rate
        code = [code;conv(data,param(k,:))];
    end
elseif tail
    data = [data,zeros(1,memory)];
    for k = 1:rate
        code = [code;conv(data,param(k,:))];
    end        
end
code = code(:,1:end-memory+1);
code = code(:);
code = mod(code,2)';

end

