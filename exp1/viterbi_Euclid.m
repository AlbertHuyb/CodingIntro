function [ans]=viterbi_Euclid(L,seq1,seq2)
%{
%    viterbi译码计算度量模块
%    （该函数只用于在viterbi.m内部调用）
%    输出参数：
%        ans:给定的两个序列之间的欧式距离
%    输入参数：
%        L:输入序列的长度
%        seq1,seq2:两个输入序列，其长度为L
%}
    ans=0;
    for i=1:L
        ans=ans+(seq1(i)-seq2(i))^2;
    end
end