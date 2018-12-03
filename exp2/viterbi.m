function [seq,path]=viterbi(n,N,poly,judge,ending,input,GF2n)
%{
%    viterbi����ģ��
%    ���������
%        seq:�����Ȼ��Ϣ���У�������Ľ������һ������
%        path:�����Ȼ��Ϣ���ж�Ӧ�ı����ķ������У���һ������
%    ���������
%        n:��1������Ϣӳ��Ϊn���ر��루��֧�ֽ�k������Ϣӳ��Ϊn���ر��룩
%        N:Լ������
%        poly:�����Ķ���ʽ��ʾ���ӵͽ׵��߽ף�����һ��������ÿһλ����Ϊ�ǰ˽�����������������Ӧ��Ϊn
%        judge:Ϊ1��ʾӲ�о���Ϊ0��ʾ���о���Ӳ�о�ʱinput������Ҫ��01���У����о�ʱû������
%        ending:Ϊ1��ʾ��β��Ϊ0��ʾ����β
%        input:����Ĵ�����ķ������У���һ������
%        GF2n:Ϊ1��ʾ1����/���ţ�Ϊ2��ʾ2����/���ţ�Ϊ3��ʾ3����/����
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