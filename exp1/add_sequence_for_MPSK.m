function [ out ] = add_sequence_for_MPSK( input, symbol_num, len)
%ADD_SEQUENCE �����ŵ�ģʽ1�������е�ǰ�߼�10�����ŵ�ȷ������
%������MPSK����λ����
% [ out ] = add_sequence( input, voltage_num )
%   input: ׼�������еĴ�
%   symbol_num: ӳ�������
%       - 2 ���ţ� ��ǰ�油��length��0
%       - 4 ���ţ� ��ǰ�油��length��00���ܳ���Ϊ2length
%       - 8 ���ţ� ��ǰ�油��length��000���ܳ���Ϊ3length
%   length: ���䳤��
out = [zeros(1,len*log2(symbol_num)),input];

end

