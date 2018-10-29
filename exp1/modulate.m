function [ symbols ] = modulate( keymethod , alphabetbits, data ,power )
%   [ symbols ] = modulate( keymethod , alphabetbits, data )
%   keymethod:  ASK for stochastic phi and PSK, AIQAM or DCQAM for definite phi
%   alphabetbits:   number of bits containing in an alphabet
%   data:   binary data completed ending by zero
%   power:  average power of voltage
len=ceil(length(data)/alphabetabits);
data=[data zeros(1,len*alphabetbits-length(data))];
data_inGF=dec2base(bin2dec(int2str(data)),2^alphabetbits);
symbol=[0,1];
stdpower=symbol*symbol'/length(symbol);
symbol=sqrt(power/stdpower)*symbol;
symbols=zeros(1,ceil(length(data)/alphabetbits));
symbols();
switch keymethod  
    case 'ASK'
        switch alphabetbits
            case 1

            case 2
                
        
        
        end
        
    case 'PSK'
        
        
        
        
        
        
    case 'QMAP'
        
        
        
        
        
        
        
        
    case 'QAM'
        if(power>)
        
        
        
        
        
        
end