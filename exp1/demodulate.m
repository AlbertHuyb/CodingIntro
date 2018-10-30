function [ data_inGF, prodata_inGF ] = demodulate( keymethod, alphabetabits, symbols ,threshould, phi )
%DEMODULATE [ data_inGF, prodata_inGF ] = demodulate( keymethod, alphabetabits, symbol ,threshould )
%   keymethod:  ASK for stochastic phi and PSK, AIQAM or DCQAM for definite phi
%   alphabetbits:   number of bits containing in an alphabet
%   symbol:   voltage symbol received
%   threshould:  average power of voltage-noise ratio



switch keymethod  
    case 'ASK_knownsigma'
        symbols = abs(symbols);
        switch alphabetabits
            case 1
                data_inGF(<symbol) = symbol(1);
                symbols(<symbo) = symbol(2);
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
        
    case 'ASK_unknownsigma'
        
        
        
        
        
    case 'PSK_knownphi'
        
    case 'PSK_unknownphi'
        

        
    case 'QAM'
        
        
        
        
        
        
        
        
    case 'BMQAM'
        bias = mean(symbols);
        symbols= 
        
        
        
        
        




end

function [ result ] = judge( out, num, mode, amp, phi ,sigma)
%JUDGE 此处显示有关此函数的摘要
%   此处显示详细说明
%   result = judge( out, num, mode, p ,amp)
%       out   收到的电平
%       num   总电平数（符号数），只解决了
%       mode  判决方式  1:未知恒定phi，推断判决  2.未知恒定phi，实时判决 3.已知恒定phi 4:
%       未知非恒定phi，未知sigma，推断判决 5.未知非恒定phi，已知知sigma
%       amp   电平幅度，未知为0
%       phi   偏移相角，未知为0
%       sigma \sigma，未知为0
%       result  第一行是硬判结果，第二行是电平为A的概率

if num == 2
    if mode == 1
        criterion = amp/2;
        result = abs(out) > criterion;
        result = amp.*result;
        result = [result;abs(out)./amp];
    elseif mode == 2
        d = abs(out);
        x = linspace(0,amp,1000);
        dtheta = 2*pi/1000;
        theta = 0:dtheta:2*pi;
        result = zeros(2,length(out));
        s = 2; %sigma used to compute probability
        for k = 1:length(out)
            distance = sqrt(d(k)^2+amp^2-2*amp*d(k).*cos(theta));
            p = 1/(sqrt(2*pi)*2*pi*amp).*exp(-distance.^2./(2*s*2*pi*amp));
            p1 = sum(p)*dtheta;
            p2 = normpdf(d(k),0,s);
            if p1 >= p2
                result(1,k) = amp;
            else
                result(1,k) = 0;
            end
            result(2,k) = p1/(p1+p2);
        end
    end
else
    result = out;
end