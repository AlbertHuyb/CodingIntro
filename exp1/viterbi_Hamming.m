function [ans]=viterbi_Hamming(L,seq1,seq2,judge)
%{
%    viterbi����������ģ��
%    ���ú���ֻ������viterbi.m�ڲ����ã�
%    ���������
%        ans:��������������֮��Ķ���
%    ���������
%        L:�������еĳ���
%        seq1,seq2:�����������У��䳤��ΪL
%        judge:Ϊ1��ʾӲ�о���Ϊ0��ʾ���о���Ӳ�о�ʱinput������Ҫ��01���У����о�ʱû������
%}
    ans=0;
    if (judge==1)
        for i=1:L
            if (seq1(i)~=seq2(i))
                ans=ans+1;
            end
        end
    else
        for i=1:L
            if (seq2(i)==1)
                ans=ans+seq1(i);
            else
                ans=ans-seq1(i);
            end
        end
    end
end