function [ans]=viterbi_Euclid(L,seq1,seq2)
%{
%    viterbi����������ģ��
%    ���ú���ֻ������viterbi.m�ڲ����ã�
%    ���������
%        ans:��������������֮���ŷʽ����
%    ���������
%        L:�������еĳ���
%        seq1,seq2:�����������У��䳤��ΪL
%}
    ans=0;
    for i=1:L
        ans=ans+(seq1(i)-seq2(i))^2;
    end
end