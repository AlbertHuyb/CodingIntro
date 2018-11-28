%{
    【椭圆曲线加密模块】
    曲线：y^2=x^3+x+1(mod 10007)
    基点g=(1,1477)，阶数n=10065
    公开定义的映射f就是恒等函数
    输入参数：
        plaintext：明文，任意长度为8的倍数的01串（不是8的倍数会在末尾补0）
        a,b,p：椭圆曲线参数
        xg,yg,n：基点及其阶数
        xk,yk：kg的两个符号，即加密密钥
%}
%function ciphertext=ECC_encrypt(plaintext,a,b,p,xg,yg,n,xk,yk)
function [ciphertext_x,ciphertext_y]=ECC_encrypt(plaintext,a,b,p,xg,yg,n,xk,yk)
    xs=[];
    ys=[];
    id=0;
    for x=0:1:p-1
        tmp=mod(x^3+a*x+b,p);
        for y=0:1:p-1
            if (mod(y^2,p)==tmp)
                id=id+1;
                xs(id)=x;
                ys(id)=y;
            end
        end
    end
    len=length(plaintext);
    if (mod(len,8)~=0)
        tmp=zeros(1,((fix(len/8)+1)*8)-len);
        plaintext=[plaintext,tmp];
        len=length(plaintext);
    end
    len=fix(len/8);
    txt=zeros(1,len);
    for i=1:1:len
        for j=1:1:8
            txt(i)=txt(i)*2;
            txt(i)=txt(i)+plaintext((i-1)*8+j);
        end
    end
    xt=[];
    yt=[];
    id=1;
    for i=1:1:len
        if (id+txt(i)>p)
            xt(i)=xs(mod(id+txt(i),p));
            yt(i)=ys(mod(id+txt(i),p));
        else
            xt(i)=xs(id+txt(i));
            yt(i)=ys(id+txt(i));
        end
        id=id+256;
        id=mod(id,p);
    end
    ciphertext_x=[];
    ciphertext_y=[];
    for i=1:1:len
        k=unidrnd(n-1);
        [xs1,ys1]=ECC_mul(a,b,p,xg,yg,k);
        [xs2,ys2]=ECC_mul(a,b,p,xk,yk,k);
        [xs2,ys2]=ECC_add(a,b,p,xs2,ys2,xt(i),yt(i));
        ciphertext_x=[ciphertext_x,xs1,xs2];
        ciphertext_y=[ciphertext_y,ys1,ys2];
    end
    ciphertext=[];
    for i=1:1:len
        for j=1:1:n-1
            if ((ciphertext_x(i*2-1)==xs(j))&&(ciphertext_y(i*2-1)==ys(j)))
                id1=j;
            end
            if ((ciphertext_x(i*2)==xs(j))&&(ciphertext_y(i*2)==ys(j)))
                id2=j;
            end
        end
        for j=1:1:16
            ciphertext=[ciphertext,mod(id1,2)];
            id1=fix(id1/2);
        end
        for j=1:1:16
            ciphertext=[ciphertext,mod(id2,2)];
            id2=fix(id2/2);
        end
    end
end