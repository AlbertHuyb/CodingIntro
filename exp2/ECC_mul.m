function [xs,ys]=ECC_mul(a,b,p,x,y,n)
    if (n==1)
        xs=x;
        ys=y;
        return;
    end
    [xt,yt]=ECC_mul(a,b,p,x,y,fix(n/2));
    [xs,ys]=ECC_add(a,b,p,xt,yt,xt,yt);
    if (mod(n,2)==1)
        [xs,ys]=ECC_add(a,b,p,xs,ys,x,y);
    end
end