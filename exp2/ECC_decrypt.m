function plaintext=ECC_decrypt(ciphertext,a,b,p,xg,yg,n,k)
    len=length(ciphertext);
    len=fix(len/32);
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
    ciphertext_x=[];
    ciphertext_y=[];
    for i=1:1:len
        id1=0;
        for j=16:-1:1
            id1=id1*2;
            id1=id1+ciphertext((i-1)*32+j);
        end
        ciphertext_x=[ciphertext_x,xs(id1)];
        ciphertext_y=[ciphertext_y,ys(id1)];
        id2=0;
        for j=16:-1:1
            id2=id2*2;
            id2=id2+ciphertext((i-1)*32+16+j);
        end
        ciphertext_x=[ciphertext_x,xs(id2)];
        ciphertext_y=[ciphertext_y,ys(id2)];
    end
    xt=[];
    yt=[];
    for i=1:1:len
        xs1=ciphertext_x(i*2-1);
        ys1=ciphertext_y(i*2-1);
        xs2=ciphertext_x(i*2);
        ys2=ciphertext_y(i*2);
        [xs1,ys1]=ECC_mul(a,b,p,xs1,ys1,k);
        ys1=mod(-1*ys1,p);
        [xt(i),yt(i)]=ECC_add(a,b,p,xs1,ys1,xs2,ys2);
    end
    txt=[];
    id=1;
    for i=1:1:len
        for j=0:1:255
            if (id+j>p)
                tmp=mod(id+j,p);
            else
                tmp=id+j;
            end
            if ((xs(tmp)==xt(i))&&(ys(tmp)==yt(i)))
                txt(i)=j;
                break;
            end
        end
        id=id+256;
        id=mod(id,p);
    end
    plaintext=zeros(1,1024);
    for i=1:1:len
        for j=8:-1:1
            plaintext((i-1)*8+j)=mod(txt(i),2);
            txt(i)=fix(txt(i)/2);
        end
    end
end