function [code]=viterbi_convolution(x,b,n,N,poly)
%{
%    viterbi译码计算卷积模块
%    （该函数只用于在viterbi.m内部调用）
%    输出参数：
%        code:卷积码编码结果
%    输入参数：
%        x:网格图中当前位置
%        b:下一步的符号
%        n:将1比特信息映射为n比特编码（不支持将k比特信息映射为n比特编码）
%        N:约束长度
%        poly:卷积码的多项式表示（从低阶到高阶），是一个向量，每一位被认为是八进制数，该向量长度应该为n
%}
    x=x-1;
    d=zeros(0,0);
    for i=1:N
        d=[d,mod(x,2)];
        x=floor(x/2);
    end
    d=[b,d];
    code=zeros(1,n);
    for i=1:n
        bit=zeros(0,0);
        while (poly(i)~=0)
            bit=[bit,mod(poly(i),10)];
            poly(i)=floor(poly(i)/10);
        end
        val=0;
        for j=length(bit):-1:1
            val=val*8;
            val=val+bit(j);
        end
        bit=zeros(0,0);
        while (val~=0)
            bit=[bit,mod(val,2)];
            val=floor(val/2);
        end
        val=0;
        for j=length(bit):-1:1
            val=val+bit(j)*d(length(bit)-j+1);
        end
        code(i)=mod(val,2);
    end
end