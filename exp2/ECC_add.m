function [xs,ys]=ECC_add(a,b,p,x1,y1,x2,y2)
    if ((x1==x2)&&(y1==y2))
        lambda=ECC_fracmod(3*x1^2+a,2*y1,p);
        xs=mod(lambda^2-x1-x2,p);
        ys=mod(lambda*(x1-xs)-y1,p);
    end
    if ((x1==x2)&&(y1~=y2))
        xs=inf;
        ys=inf;
    end
    if (x1~=x2)
        lambda=ECC_fracmod(y2-y1,x2-x1,p);
        xs=mod(lambda^2-x1-x2,p);
        ys=mod(lambda*(x1-xs)-y1,p);
    end
end