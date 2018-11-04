function [ data_inGF, prodata_inGF ] = demodulate_for_ask_qam( keymethod, alphabetabits, symbols ,symbol )
%DEMODULATE [ data_inGF, prodata_inGF ] = demodulate( keymethod, alphabetabits, symbol ,threshould )
%   keymethod:  ASK for stochastic phi and PSK, AIQAM or DCQAM for definite phi
%   alphabetbits:   number of bits containing in an alphabet
%   symbol:   voltage symbol received
%   threshould:  average power of voltage-noise ratio

data_inGF = zeros(1,length(symbols));
prodata_inGF = zeros(2^alphabetabits,length(symbols));
switch keymethod
    case 'ASK'
        symbols = abs(symbols);
        prodata_inGF= (-0.5*repmat(symbol.',1,length(symbols)).^2)+log(besseli(0,symbol'*symbols));
        [~,data_inGF] = max(prodata_inGF);
        data_inGF = data_inGF-1;
    case '8QAM1'
        switch alphabetabits
            case 3
                avg_vec = mean(symbols);
                phi0 = angle(avg_vec);
                bias_ratio = abs(mean(symbol));
                symbols = symbols.*exp(-1i*phi0)-bias_ratio;
                prodata_inGF = -abs(repmat(symbols,8,1)-repmat((symbol-bias_ratio).',1,length(symbols))).^2;
                %data_inGF = mod(find(prodata_inGF==max(prodata_inGF)),8)';
                %data_inGF(data_inGF==0) = 2^alphabetabits;
                [~,data_inGF] = max(prodata_inGF);
                data_inGF = data_inGF -1;
            otherwise
                error('you cant use 8QAM1');
        end
    case '8QAM2'
        switch alphabetabits
            case 3
                avg_vec = mean(symbols);
                phi0 = angle(avg_vec)+3*pi/4;%[-pi,pi]-pi/4;
                symbols = symbols.*exp(-1i*phi0);
                prodata_inGF = -abs(repmat(symbols,8,1)-repmat(symbol.',1,length(symbols))).^2;
%                 data_inGF = mod(find(prodata_inGF==max(prodata_inGF)),8)';
%                 data_inGF(data_inGF==0) = 2^alphabetabits;
                [~,data_inGF] = max(prodata_inGF);
                data_inGF = data_inGF -1;
            otherwise
                error('you cant use 8QAM2');
        end
        case '8QAM3'
        switch alphabetabits
            case 3
                avg_vec = mean(symbols);
                phi0 = angle(avg_vec);
                bias_ratio = abs(mean(symbol));
                symbols = symbols.*exp(-1i*phi0)-bias_ratio;
                prodata_inGF = -abs(repmat(symbols,8,1)-repmat((symbol-bias_ratio).',1,length(symbols))).^2;
                %data_inGF = mod(find(prodata_inGF==max(prodata_inGF)),8)';
                %data_inGF(data_inGF==0) = 2^alphabetabits;
                [~,data_inGF] = max(prodata_inGF);
                data_inGF = data_inGF -1;
            otherwise
                error('you cant use 8QAM3');
        end
end