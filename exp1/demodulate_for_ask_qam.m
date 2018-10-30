function [ data_inGF, prodata_inGF ] = demodulate_for_ask_qam( keymethod, alphabetabits, symbols ,SNR)
%DEMODULATE [ data_inGF, prodata_inGF ] = demodulate( keymethod, alphabetabits, symbol ,threshould )
%   keymethod:  ASK for stochastic phi and PSK, AIQAM or DCQAM for definite phi
%   alphabetbits:   number of bits containing in an alphabet
%   symbol:   voltage symbol received
%   threshould:  average power of voltage-noise ratio

data_inGF = zeros(1,length(symbols));
switch keymethod
    case 'ASK'
        symbols = abs(symbols);
        [~,threshould,~]=designask();
        switch alphabetabits
            case 1
                data_inGF(symbols<threshould(2)) = 0;
                data_inGF(threshould(2)<symbols) = 1;
            case 2
                data_inGF(symbols<threshould(2)) = 0;
                data_inGF(threshould(2)<symbols&symbols<threshould(3)) = 1;
                data_inGF(threshould(3)<symbols&symbols<threshould(4)) = 2;
                data_inGF(threshould(4)<symbols) = 3;
            case 3
                data_inGF(symbols<threshould(2)) = 0;
                data_inGF(threshould(2)<symbols&symbols<threshould(3)) = 1;
                data_inGF(threshould(3)<symbols&symbols<threshould(4)) = 2;
                data_inGF(threshould(4)<symbols&symbols<threshould(5)) = 3;
                data_inGF(threshould(5)<symbols&symbols<threshould(6)) = 4;
                data_inGF(threshould(6)<symbols&symbols<threshould(7)) = 5;
                data_inGF(threshould(7)<symbols&symbols<threshould(8)) = 6;
                data_inGF(threshould(8)<symbols) = 7;
        end
        
        
        
    case '8QAM1'
        
        
    case '8QAM2'
        avg_vec = sum(symbols)/length(symbols);
        phi0 = angle(avg_vec)-pi/4;%[-pi,pi]-pi/4;
        symbols_correct = symbols.*exp(-1i*phi0);
        real_part = real(symbols_correct);
        imag_part = imag(symbols_correct);
        angle_part = angle(symbols_correct);
        symbol = [-1+1j,1j,-1,0,1,-1-1j,-1j,1-1j];
        amplify = sqrt(10^(SNR/10)/(symbol*symbol'/length(symbol)));
        switch alphabetabits
            case 3
                data_inGF(real_part<-amplify/2 & imag_part > amplify/2) = 0;
                data_inGF(real_part>-amplify/2 & imag_part > amplify/2 & angle_part > pi/4) = 1;
                data_inGF(real_part<-amplify/2 & imag_part > -amplify/2 & imag_part < amplify/2) = 2;
                data_inGF(threshould(4)<symbols&&symbols<threshould(5)) = 3;
                data_inGF(threshould(5)<symbols&&symbols<threshould(6)) = 4;
                data_inGF(threshould(6)<symbols&&symbols<threshould(7)) = 5;
                data_inGF(threshould(7)<symbols&&symbols<threshould(8)) = 6;
                data_inGF(threshould(8)<symbols) = 7;
            otherwise
                error('you cant use 8QAM2');
        end
        

end