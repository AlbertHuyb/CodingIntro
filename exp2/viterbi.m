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
        L=length(input)/(2^n);
    end
    dis=Inf(1,2^N);
    back_index = zeros(2^N,L);
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
%                     for t=1:L*n
%                         new_survival(k,t)=survival(j,t);
%                     end
                    back_index(k,i) = j;
%                     for t=1:L
%                         new_estimation(k,t)=estimation(j,t);
%                     end
                end
                k=viterbi_extend(j,1,N);
                val=dis(j);
                code=viterbi_convolution(j,1,n,N,poly);
                val=val+viterbi_Hamming(n,input(n*(i-1)+1:n*i),code);
                if (val<new_dis(k))
                    new_dis(k)=val;
                    back_index(k,i) = j;
                end
            end
            dis=new_dis;
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
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,1);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        back_index(k,i) = j;
                    end
                    k=viterbi_extend(j,1,N);
                    val=dis(j);
                    code=viterbi_convolution(j,1,n,N,poly);
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,1);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        back_index(k,i) = j;
                    end
                end
                dis=new_dis;
            end
        elseif (GF2n==2)
            for i=1:L
                new_dis=Inf(1,2^N);
                for j=1:2^N
                    k=viterbi_extend(j,0,N);
                    val=dis(j);
                    code=viterbi_convolution(j,0,n,N,poly);
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,2);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        back_index(k,i) = j;
                    end
                    k=viterbi_extend(j,1,N);
                    val=dis(j);
                    code=viterbi_convolution(j,1,n,N,poly);
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,2);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        back_index(k,i) = j;
                    end
                end
                dis=new_dis;
            end
        else
            for i=1:L
                new_dis=Inf(1,2^N);
                for j=1:2^N
                    k=viterbi_extend(j,0,N);
                    val=dis(j);
                    code=viterbi_convolution(j,0,n,N,poly);
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,3);
                    if (val<new_dis(k))
                        new_dis(k)=val;
                        back_index(k,i) = j;
                    end
                    k=viterbi_extend(j,1,N);
                    val=dis(j);
                    code=viterbi_convolution(j,1,n,N,poly);
                    val=val+viterbi_Euclid(n,input((2^n)*(i-1)+1:(2^n)*i),code,3);
                    if (val<new_dis(k))
                    new_dis(k)=val;
                    back_index(k,i) = j;
                    end
                end
                dis=new_dis;
            end
        end
    end
    id=1;
    if (ending==0)
        [~,id] = min(dis);
    end
    seq = zeros(1,L);
    for i=L:-1:1
        seq(i)=mod(id-1,2);
        id = back_index(id,i);
    end
    if (ending==1)
        seq = seq(1:end-2^n);
    end
end