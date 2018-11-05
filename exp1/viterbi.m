function [seq,path]=viterbi(n,N,poly,judge,ending,input,GF2n)
%{
%    viterbi译码模块
%    输出参数：
%        seq:最大似然信息序列，即译码的结果，是一个向量
%        path:最大似然信息序列对应的编码后的符号序列，是一个向量
%    输入参数：
%        n:将1比特信息映射为n比特编码（不支持将k比特信息映射为n比特编码）
%        N:约束长度
%        poly:卷积码的多项式表示（从低阶到高阶），是一个向量，每一位被认为是八进制数，该向量长度应该为n
%        judge:为1表示硬判决，为0表示软判决，硬判决时input序列需要是01序列，软判决时没有限制
%        ending:为1表示收尾，为0表示不收尾
%        input:输入的待译码的符号序列，是一个向量
%        GF2n:为1表示1比特/符号，为2表示2比特/符号，为3表示3比特/符号
%}
    if (judge==1)
        L=length(input)/n;
    else
        if (GF2n==1)
            L=length(input)/4;
        elseif (GF2n==2)
            L=length(input)/4;
        else
        end
    end
    dis=Inf(1,2^N);
    survival=zeros(2^N,L*n);
    estimation=zeros(2^N,L);
    new_survival=zeros(2^N,L*n);
    new_estimation=zeros(2^N,L);
    dis(1)=0;
    if (judge==1)
        for i=1:L
            new_dis=Inf(1,2^N);
            for j=1:2^N
                k=viterbi_extend(j,0,N);
                val=dis(j);
                code=viterbi_convolution(j,0,n,N,poly);
                val=val+viterbi_Hamming(n,input(n*(i-1)+1:n*i),code);
                if (val<new_dis(k))
                    new_dis(k)=val;
                    for t=1:L*n
                        new_survival(k,t)=survival(j,t);
                    end
                    new_survival(k,n*(i-1)+1:n*i)=code;
                    for t=1:L
                        new_estimation(k,t)=estimation(j,t);
                    end
                    new_estimation(k,i)=0;
                end
                k=viterbi_extend(j,1,N);
                val=dis(j);
                code=viterbi_convolution(j,1,n,N,poly);
                val=val+viterbi_Hamming(n,input(n*(i-1)+1:n*i),code);
                if (val<new_dis(k))
                new_dis(k)=val;
                    for t=1:L*n
                        new_survival(k,t)=survival(j,t);
                    end
                    new_survival(k,n*(i-1)+1:n*i)=code;
                    for t=1:L
                        new_estimation(k,t)=estimation(j,t);
                    end
                    new_estimation(k,i)=1;
                end
            end
            dis=new_dis;
            survival=new_survival;
            estimation=new_estimation;
        end
    else
        input=exp(input);
        if (GF2n==1)
            for i=1:L
                new_dis=Inf(1,2^N);
                for j=1:2^N
                    k=viterbi_extend(j,0,N);
                    val=dis(j);
                    code=viterbi_convolution(j,0,n,N,poly);
                    val=val+viterbi_Euclid(n,input(4*(i-1)+1:4*i),code,1);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        for t=1:L*n
                            new_survival(k,t)=survival(j,t);
                        end
                        new_survival(k,n*(i-1)+1:n*i)=code;
                        for t=1:L
                            new_estimation(k,t)=estimation(j,t);
                        end
                        new_estimation(k,i)=0;
                    end
                    k=viterbi_extend(j,1,N);
                    val=dis(j);
                    code=viterbi_convolution(j,1,n,N,poly);
                    val=val+viterbi_Euclid(n,input(4*(i-1)+1:4*i),code,1);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        for t=1:L*n
                            new_survival(k,t)=survival(j,t);
                        end
                        new_survival(k,n*(i-1)+1:n*i)=code;
                        for t=1:L
                            new_estimation(k,t)=estimation(j,t);
                        end
                        new_estimation(k,i)=1;
                    end
                end
                dis=new_dis;
                survival=new_survival;
                estimation=new_estimation;
            end
        elseif (GF2n==2)
            for i=1:L
                new_dis=Inf(1,2^N);
                for j=1:2^N
                    k=viterbi_extend(j,0,N);
                    val=dis(j);
                    code=viterbi_convolution(j,0,n,N,poly);
                    val=val+viterbi_Euclid(n,input(4*(i-1)+1:4*i),code,2);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        for t=1:L*n
                            new_survival(k,t)=survival(j,t);
                        end
                        new_survival(k,n*(i-1)+1:n*i)=code;
                        for t=1:L
                            new_estimation(k,t)=estimation(j,t);
                        end
                        new_estimation(k,i)=0;
                    end
                    k=viterbi_extend(j,1,N);
                    val=dis(j);
                    code=viterbi_convolution(j,1,n,N,poly);
                    val=val+viterbi_Euclid(n,input(4*(i-1)+1:4*i),code,2);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        for t=1:L*n
                            new_survival(k,t)=survival(j,t);
                        end
                        new_survival(k,n*(i-1)+1:n*i)=code;
                        for t=1:L
                            new_estimation(k,t)=estimation(j,t);
                        end
                        new_estimation(k,i)=1;
                    end
                end
                dis=new_dis;
                survival=new_survival;
                estimation=new_estimation;
            end
        else
        end
    end
    id=1;
    if (ending==0)
        for i=2:2^N
            if (dis(i)<dis(id))
                id=i;
            end
        end
    end
    for i=1:L*n
        path(i)=survival(id,i);
    end
    for i=1:L
        seq(i)=estimation(id,i);
    end
end