function [ code ] = convcode( data, param, tail )
%CONVCODE 卷积编码 depend on matlab r2016a
%   convcode(data,rate,param,tail)
%       data:    0 1 序列，待编码内容
%       param:   列表，其中包括每个通道的8进制参数(数字格式),
%                编码效率为1/n时，这里应该有n个元素
%       tail:    0表示不收尾，1表示收尾

rate = length(param);
param = num2str(reshape(param,rate,1));
param = base2dec(param,8);
param = dec2bin(param);
param = double(param == '1');
memory =size(param,2);
code = [];
for k = [1:rate]
    code = [code;conv(data,param(k,:))];
end
if ~tail
    code = code(:,1:end-memory+1);
end
code = code(:);
code = mod(code,2)';

end

