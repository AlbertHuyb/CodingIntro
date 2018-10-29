clear all;
a = ones(1,100)*3;
len = [1:50];
error = zeros(1,length(len));
sigma = 1;
SNR=10*log10(9/2/sigma^2)
for k=1:length(len)
for t=1:10
    phi0 = random('unif',0,2*pi);
    phi = repmat(phi0,1,length(a));
    n_r = sigma.*randn(1,length(a));
    n_i = sigma.*randn(1,length(a));
    n = n_r + i*n_i;
    output = a.*exp(i.*phi)+n;
    avg = sum(output(1:len(k)))/len(k);
    aa = angle(avg);
    if(aa<0)
        aa = aa+2*pi;
    end
    error(k) = error(k)+abs(aa-phi0)/phi0;
end
error(k)=error(k)/10;
end