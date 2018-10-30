function [ symbols, symbol, pcorrect ] = modulate_for_ask_qam( keymethod , alphabetabits, data ,SNR , bias_ratio , gray_enable)
%   [ symbols ] = modulate( keymethod , alphabetbits, data )
%   keymethod:  ASK for stochastic phi and PSK(bias_ratio=0), BPSK for
%   definite phi, 8QAM
%   alphabetbits:   number of bits containing in an alphabet
%   data:   binary data completed ending by zero
%   SNR:  average power of voltage-noise ratio
%   gray_enable: bin2gray

len = ceil(length(data)/alphabetabits);
data = [data zeros(1,len*alphabetabits-length(data))];
data_inGF = str2int(dec2base(bin2dec(int2str(data)),2^alphabetabits));
symbols = zeros(1,ceil(length(data)/alphabetabits));
if(gray_enable)
    data_inGF = bin2gray(data_inGF,'psk',alphabetalen);
end
switch keymethod
    case 'ASK'
        [ symbol, ~, pcorrect ] = designask(alphabetabits,SNR);
    case 'BPSK'
        Amplify=sqrt(2*10^(SNR/10)/(bias_ratio^2+1));
        symbol = 1:alphabetalen;
        phi = 2*pi/alphabetabits*(symbol);
        symbol = reshape(Amplify.*exp(1i*phi),1,length(phi))+bias_ratio*Amplify;
    case '8QAM1'
        symbol = [-(2+3^0.5)^0.5+1j*(2+3^0.5)^0.5,(2+3^0.5)^0.5+1j*(2+3^0.5)^0.5,1j*2^0.5,2^0.5,-(2+3^0.5)^0.5-1j*(2+3^0.5)^0.5,(2+3^0.5)^0.5-1j*(2+3^0.5)^0.5,-2^0.5,-1j*2^0.5]+bias_ratio*(2+3^0.5);
        symbol = sqrt(10^(SNR/10)/(symbol*symbol'/length(symbol))).*symbol;
    case '8QAM2'
        symbol = [-1+1j,1j,-1,0,1,-1-1j,-1j,1-1j];
        symbol = sqrt(10^(SNR/10)/(symbol*symbol'/length(symbol))).*symbol;
end
switch alphabetabits
    case 1
        symbols(data_inGF==0) = symbol(1);
        symbols(data_inGF==1) = symbol(2);
    case 2
        symbols(data_inGF==0) = symbol(1);
        symbols(data_inGF==1) = symbol(2);
        symbols(data_inGF==2) = symbol(3);
        symbols(data_inGF==3) = symbol(4);
    case 3
        symbols(data_inGF==0) = symbol(1);
        symbols(data_inGF==1) = symbol(2);
        symbols(data_inGF==2) = symbol(3);
        symbols(data_inGF==3) = symbol(4);
        symbols(data_inGF==4) = symbol(5);
        symbols(data_inGF==5) = symbol(6);
        symbols(data_inGF==6) = symbol(7);
        symbols(data_inGF==7) = symbol(8);
end
end