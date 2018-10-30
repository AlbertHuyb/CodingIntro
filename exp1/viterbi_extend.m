function [y]=viterbi_extend(x,b,N)
%{
%    viterbi译码计算网格图转移模块
%    （该函数只用于在viterbi.m内部调用）
%    输出参数：
%        y:网格图下一步转移到的位置
%    输入参数：
%        x:网格图中当前位置
%        b:下一步的符号
%        N:约束长度
%}
    x=x-1;
    d=zeros(0,0);
    for i=1:N
        d=[d,mod(x,2)];
        x=floor(x/2);
    end
    d=[b,d];
    y=0;
    for i=N:-1:1
        y=y*2;
        y=y+d(i);
    end
    y=y+1;
end