function [ output ] = channel( input ,mode, sigma )
%[ output ] = channel( input ,mode, sigma )
%   mode:    1 definite phi ; 2 different phi each time
%   sigma:   power of noise in real and imag part      

switch mode
    case 1
        phi = random('unif',0,2*pi);
        phi = repmat(phi,1,length(input));
    case 2
        phi = random('unif',0,2*pi,1,length(input));
    otherwise
        error('Ä£Ê½´íÎó')
end
n_r = sigma.*randn(1,length(input));
n_i = sigma.*randn(1,length(input));
n = n_r + i*n_i;
output = input.*exp(i.*phi)+n;
end

