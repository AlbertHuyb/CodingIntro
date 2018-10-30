function [ans]=viterbi_Hamming(L,seq1,seq2,judge)
%{
%    viterbi译码计算度量模块
%    （该函数只用于在viterbi.m内部调用）
%    输出参数：
%        ans:给定的两个序列之间的度量
%    输入参数：
%        L:输入序列的长度
%        seq1,seq2:两个输入序列，其长度为L
%        judge:为1表示硬判决，为0表示软判决，硬判决时input序列需要是01序列，软判决时没有限制
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