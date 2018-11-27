function [code]=viterbi_convolution(x,b,n,N,poly)
%{
%    viterbi���������ģ��
%    ���ú���ֻ������viterbi.m�ڲ����ã�
%    ���������
%        code:����������
%    ���������
%        x:����ͼ�е�ǰλ��
%        b:��һ���ķ���
%        n:��1������Ϣӳ��Ϊn���ر��루��֧�ֽ�k������Ϣӳ��Ϊn���ر��룩
%        N:Լ������
%        poly:�����Ķ���ʽ��ʾ���ӵͽ׵��߽ף�����һ��������ÿһλ����Ϊ�ǰ˽�����������������Ӧ��Ϊn
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