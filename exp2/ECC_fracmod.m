function ans=ECC_fracmod(a,b,m)
    a=mod(a,m);
    b=mod(b,m);
    i=1;
    while (mod(b*i,m)~=1)
        i=i+1;
    end
    ans=mod(a*i,m);
end