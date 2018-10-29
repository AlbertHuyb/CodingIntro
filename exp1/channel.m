function [ output ] = channel( input, phi, sigma )
%   [ output ] = channel( input ,mode, sigma )
%   input:  symbols modulated by sender
%   phi:  0 different phi each time, r.v. \sim U[0,2*pi] ; or input
%   definite phi \in (0,2*pi] well-defined
%   sigma:   power of noise in real and imag part
if phi==0
    phi = repmat(phi,1,length(input));
else
    phi = random('unif',0,2*pi,1,length(input));
end
n_r = sigma.*randn(1,length(input));
n_i = sigma.*randn(1,length(input));
n = n_r + 1i*n_i;
output = input.*exp(1i.*phi)+n;
end
