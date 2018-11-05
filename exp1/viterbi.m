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