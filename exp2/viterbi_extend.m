function [y]=viterbi_extend(x,b,N)
%{
%    viterbi�����������ͼת��ģ��
%    ���ú���ֻ������viterbi.m�ڲ����ã�
%    ���������
%        y:����ͼ��һ��ת�Ƶ���λ��
%    ���������
%        x:����ͼ�е�ǰλ��
%        b:��һ���ķ���
%        N:Լ������
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